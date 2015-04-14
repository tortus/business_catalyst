# encoding: utf-8
module BusinessCatalyst
  module CSV

    class ProductCodeTransformer < Transformer

      def initialize(input)
        if input.blank?
          raise ArgumentError, "product code must not be blank"
        end
        super(input)
      end

    end

  end
end
