# encoding: utf-8

module BusinessCatalyst
  module CSV
    # Validates a product code and converts it to String.
    class ProductCodeTransformer < Transformer

      def initialize(input)
        if input.blank?
          raise InvalidInputError, "product_code must not be blank"
        end
        super(input)
      end

      def transform
        input.to_s
      end

    end
  end
end
