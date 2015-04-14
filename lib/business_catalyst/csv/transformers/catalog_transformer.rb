# encoding: UTF-8
module BusinessCatalyst
  module CSV

    class CatalogTransformer < Transformer
      def normalized_input
        # ensure at least a 1D array
        normalized_input = input.kind_of?(Array) ? input : [input]

        # now convert to 2D array
        unless normalized_input.first.kind_of?(Array)
          normalized_input = [normalized_input]
        end

        normalized_input
      end

      def transform
        normalized_input.map { |catalog_names|
          if catalog_names.any?
            sanitized_names = catalog_names.map { |name|
              BusinessCatalyst.sanitize_catalog_name(name)
            }
            "/" + sanitized_names.join("/")
          end
        }.join(";")
      end
    end

  end
end
