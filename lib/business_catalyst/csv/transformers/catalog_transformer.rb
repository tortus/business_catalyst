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
        normalized_input.map { |path|
          if path.any?
            sanitized_names = path.map { |name|
              BusinessCatalyst.sanitize_catalog_name(name)
            }
            "/" + sanitized_names.join("/")
          end
        }.join(";")
      end
    end

  end
end
