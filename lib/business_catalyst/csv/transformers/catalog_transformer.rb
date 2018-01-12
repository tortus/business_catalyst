# encoding: UTF-8

module BusinessCatalyst
  module CSV
    # Convert arrays of paths to sanitized catalog paths joined by ';'
    class CatalogTransformer < Transformer

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

      def normalized_input
        # ensure at least a 1D array
        normalized_input = input.is_a?(Array) ? input : [input]

        # now convert to 2D array
        unless normalized_input.first.is_a?(Array)
          normalized_input = [normalized_input]
        end

        normalized_input
      end

    end
  end
end
