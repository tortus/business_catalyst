# encoding: utf-8
module BusinessCatalyst
  module CSV

    class NoSuchColumnError < StandardError; end

    # Shared logic for building a row for a CSV export for Business Catalust.
    # Instead of sublcassing Row directly in your project, subclass CatalogRow
    # or ProductRow, which have column definitions set up for those tables.
    class Row
      def initialize(*args)
      end

      # Override to return Array of column config Arrays in the format:
      #
      #   [
      #     ["Header", :mapping_name, default_value, TransformerClass],
      #     ...
      #   ]
      #
      # "default_value" and "TransformerClass" are optional, and will default to nil and
      # GenericTransformer, respectively, if not specified.
      def self.columns
        raise NotImplementedError, "Implement to return Array of column config Arrays in the format: [[\"Header\", :mapping_name, default_value, TransformerClass]]"
      end

      # Define value for BC column using a block. Column argument should be
      # one of the mapping name symbols returned by Row.columns.
      def self.map(column, &block)
        unless columns.any? {|c| c[1] == column}
          raise NoSuchColumnError, "no such column '#{column.inspect}'"
        end
        define_method(column, &block)
      end

      # Set the default currency for the current application.
      # Alias for CurrencyTransformer.default_currency=
      #
      #   class MyRow < BusinessCatalyst::CSV:Row
      #     default_currency "US"
      #   end
      #
      def self.default_currency(currency)
        CurrencyTransformer.default_currency = currency
      end

      def to_a
        self.class.columns.map { |column|
          csv_value(column[1], column)
        }
      end

      def self.headers
        @headers ||= columns.map(&:first)
      end

      def csv_value(method, config = nil)
        config ||= self.class.columns.find {|c| c[1] == method}
        raise NoSuchColumnError, "no configuration found for #{method.inspect} in #{self.class.to_s}.columns" if config.nil?

        input = if respond_to?(method)
                  send(method)
                else
                  config.fetch(2, nil)
                end

        transformer = config.fetch(3, GenericTransformer)
        transformer.transform(input)
      end

    end

  end
end
