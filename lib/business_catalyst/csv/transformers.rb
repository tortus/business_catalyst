# encoding: utf-8

require 'business_catalyst/csv/transformers/invalid_input_error'
require 'business_catalyst/csv/transformers/transformer'
require 'business_catalyst/csv/transformers/catalog_transformer'
require 'business_catalyst/csv/transformers/currency_transformer'
require 'business_catalyst/csv/transformers/product_attributes_transformer'
require 'business_catalyst/csv/transformers/product_code_transformer'
require 'business_catalyst/csv/transformers/seo_friendly_url_transformer'
require 'business_catalyst/csv/transformers/uri_array_transformer'
require 'business_catalyst/csv/transformers/uri_transformer'

module BusinessCatalyst
  module CSV
    # Just calls to_s on input if not nil
    class GenericTransformer < Transformer
      def transform
        input.to_s if input
      end
    end

    # Join an array of Strings with ';'
    class ArrayTransformer < Transformer
      def transform
        return nil unless input
        Array(input).map { |s| s.to_s.gsub(";", " ") }.join(";")
      end
    end

    # Convert a truthy or falsy value to 'Y' or 'N'.
    class BooleanTransformer < Transformer
      def transform
        input ? "Y" : "N"
      end
    end

    # Convert a template ID symbol (:default / :none / :parent)
    # to the integer that BC understands.
    #
    # Passes integers through as-is.
    class TemplateIDTransformer < Transformer
      def transform
        return nil unless input
        if input.is_a?(Symbol)
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
