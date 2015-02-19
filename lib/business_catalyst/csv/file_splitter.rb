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
    #     splitter = FileSplitter.new("output_base_name.csv", max_rows_per_file: 10_000, header_row: headers)
    #     splitter.start do |splitter|
    #       product_rows.each do |row|
    #         splitter.start_row
    #         splitter.current_file << row.to_a
    #       end
    #     end
    #
    class FileSplitter

      attr_accessor :base_name, :max_rows_per_file, :header_row, :verbose, :logger
      attr_reader :current_row, :total_rows, :current_file, :all_files

      def initialize(base_name, max_rows_per_file: 10_000, header_row: nil, verbose: false)
        @base_name = base_name
        @max_rows_per_file = max_rows_per_file
        @header_row = header_row
        @verbose = verbose

        @current_row = 0
        @total_rows = 0

        @all_files = []
        @current_file = nil
      end

      def start
        begin
          increment_file(1, max_rows_per_file) # will be of by one unless we set manually
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
      end

      def file_name_with_range(file_name, min, max)
        file_name.sub(/(\.[\w\d]+$|$)/, "_rows_#{min}-#{max}\\1")
      end

      def rename_last_file
        last_file = @all_files.pop
        if last_file
          new_name = last_file.sub(/-\d+(\.[\w\d]+)?$/, "-#{total_rows}\\1")
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
