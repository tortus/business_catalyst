# encoding: utf-8
module BusinessCatalyst
  module CSV


    class Transformer
      attr_accessor :input

      def initialize(input)
        @input = input
      end

      def transform
        raise NotImplementedError, "Transformer subclasses must implement #transform"
      end

      def self.transform(input)
        self.new(input).transform
      end
    end


    # Just calls to_s on input
    class GenericTransformer < Transformer
      def transform
        input.to_s if input
      end
    end


    class ArrayTransformer < Transformer
      def transform
        if input
          input.map {|s| s.to_s.gsub(";", " ") }.join(";")
        end
      end
    end


    class BooleanTransformer < Transformer
      def transform
        input ? "Y" : "N"
      end
    end


    class CatalogTransformer < Transformer
      def transform
        # ensure at least a 1D array
        normalized_input = input.kind_of?(Array) ? input : [input]

        # now convert to 2D array
        unless normalized_input.first.kind_of?(Array)
          normalized_input = [normalized_input]
        end

        normalized_input.map { |catalog_names|
          if catalog_names.any?
            sanitized_names = catalog_names.map { |name|
              BusinessCatalyst.sanitize_catalog_name(name, :replace_with => " ", :ampersand_as => "and", :squish => true)
            }
            "/" + sanitized_names.join("/")
          end
        }.join(";")
      end
    end


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