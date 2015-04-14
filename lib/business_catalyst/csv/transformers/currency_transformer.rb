# encoding: utf-8
module BusinessCatalyst
  module CSV

    class CurrencyTransformer < Transformer
      BC_CURRENCY_REGEX = /\A\w+\/\d/.freeze

      def self.default_currency
        @default_currency || "US"
      end

      def self.default_currency=(currency)
        @default_currency = currency
      end

      attr_accessor :currency

      def initialize(input, currency = nil)
        @currency = currency || self.class.default_currency
        super(input)
      end

      def transform
        if input
          inputs = Array(input).map {|n| number_to_currency(n) }.compact
          if inputs.any?
            inputs.join(";")
          end
        end
      end

      def number_to_currency(input)
        if input && (input_s = input.to_s.strip) != ""
          if input_s =~ BC_CURRENCY_REGEX
            input_s
          else
            "#{currency}/#{input_s}"
          end
        end
      end
    end

  end
end
