# encoding: utf-8
require 'csv'
require 'fileutils'

module BusinessCatalyst
  module CSV

    # Business Catalyst can only import 10k product rows at a time.
    # Use this class to help split up files.
    #
    # == Usage
    #
    #     headers = MyRowClass.headers
    #     splitter = FileSplitter.new("output_base_name", max_rows_per_file: 10_000, header_row: headers)
    #     splitter.start do |splitter|
    #       product_rows.each do |row|
    #         splitter.start_row
    #         splitter.current_file << row.to_a
    #       end
    #     end
    #
    # If you want to watch for when a new file is opened and maybe
    # do some logging, you can use the #on_file_change method:
    #
    #     splitter.on_file_change do |splitter|
    #       puts "opened #{splitter.current_file.path}"
    #     end
    #
    class FileSplitter

      attr_accessor :base_name, :max_rows_per_file, :header_row, :verbose, :logger
      attr_reader :current_row, :total_rows, :current_file, :all_files

      alias_method :file_names, :all_files

      def initialize(base_name, options = {})
        @base_name = base_name
        @max_rows_per_file = options.fetch(:max_rows_per_file) { 10_000 }
        @header_row = options.fetch(:header_row) { nil }
        @verbose = options.fetch(:verbose) { false }
        @logger = options.fetch(:logger) { nil }

        @current_row = 0
        @total_rows = 0

        @all_files = []
        @current_file = nil
      end

      def start
        begin
          increment_file(1, max_rows_per_file) # will be off by one unless we set manually
          yield self
        ensure
          close
        end
        rename_last_file
      end

      # Call before writing new row
      def start_row
        @current_row += 1
        @total_rows += 1
        if @current_row > max_rows_per_file
          increment_file
          @current_row = 1
        end
      end

      def on_file_change(&block)
        @on_file_change = Proc.new(&block)
      end

      def close
        current_file.close if current_file
      end

    private

      def increment_file(min_row = total_rows, max_row = total_rows + max_rows_per_file - 1)
        @current_file.close if @current_file
        new_file_name = file_name_with_range(base_name, min_row, max_row)
        @all_files << new_file_name
        log "writing to #{new_file_name}" if verbose
        @current_file = ::CSV.open(new_file_name, 'wb')
        if header_row
          @current_file << header_row
        end
        trigger_on_file_change
      end

      def trigger_on_file_change
        if @on_file_change.kind_of?(Proc)
          if @on_file_change.arity >= 1
            @on_file_change.call(self)
          else
            @on_file_change.call
          end
        end
      end

      def file_name_with_range(base_name, min, max)
        "#{base_name}_rows_#{min}-#{max}.csv"
      end

      def rename_last_file
        last_file = @all_files.pop
        if last_file
          new_name = last_file.sub(/-\d+\.csv\z/i, "-#{total_rows}.csv")
          FileUtils.mv last_file, new_name
          @all_files << new_name
        end
      end

      def log(msg)
        if logger
          logger.info msg
        else
          puts msg
        end
      end

    end
  end
end
