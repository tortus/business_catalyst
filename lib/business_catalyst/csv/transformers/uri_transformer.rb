# encoding: UTF-8
module BusinessCatalyst
  module CSV

    class URITransformer < Transformer

      def transform
        URI.encode(input) if input
      end

    end

  end
end
