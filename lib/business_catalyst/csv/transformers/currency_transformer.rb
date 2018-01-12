# encoding: utf-8

module BusinessCatalyst
  module CSV
    # Convert all manner of input to BC currency strings
    class CurrencyTransformer < Transformer

      BC_CURRENCY_REGEX = %r{\A\w+/\d}

      class << self
        def default_currency
          @default_currency || "US".freeze
        end

        attr_writer :default_currency
      end

      attr_accessor :currency

      def initialize(input, currency = nil)
        @currency = currency || self.class.default_currency
        super(input)
      end

      def transform
        return nil unless input

        inputs = Array(input).map { |n| number_to_currency(n) }.compact
        return nil unless inputs.any?

        inputs.join(";")
      end

      def number_to_currency(input)
        return nil unless input

        input_s = input.is_a?(BigDecimal) ? input.to_s('F') : input.to_s.strip
        return nil if input_s.empty?

        if bc_currency_string?(input_s)
          input_s
        else
          "#{currency}/#{input_s}"
        end
      end

      def bc_currency_string?(input)
        !!(input =~ BC_CURRENCY_REGEX)
      end

    end
  end
end
