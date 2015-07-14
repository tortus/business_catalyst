# encoding: utf-8
require 'business_catalyst/csv/transformers/invalid_input_error'
require 'business_catalyst/csv/transformers/transformer'
require 'business_catalyst/csv/transformers/catalog_transformer'
require 'business_catalyst/csv/transformers/currency_transformer'
require 'business_catalyst/csv/transformers/product_attributes_transformer'
require 'business_catalyst/csv/transformers/product_code_transformer'
require 'business_catalyst/csv/transformers/seo_friendly_url_transformer'
require 'business_catalyst/csv/transformers/uri_transformer'

module BusinessCatalyst
  module CSV

    # Just calls to_s on input
    class GenericTransformer < Transformer
      def transform
        input.to_s if input
      end
    end


    class ArrayTransformer < Transformer
      def transform
        if input
          Array(input).map {|s| s.to_s.gsub(";", " ") }.join(";")
        end
      end
    end


    class BooleanTransformer < Transformer
      def transform
        input ? "Y" : "N"
      end
    end

    class TemplateIDTransformer < Transformer
      def transform
        if input.kind_of?(Symbol)
          case input
          when :default
            0
          when :none
            -1
          when :parent
            -2
          else
            raise InvalidInputError, "#{input} is not a valid template ID"
          end
        else
          input
        end
      end
    end

  end
end
