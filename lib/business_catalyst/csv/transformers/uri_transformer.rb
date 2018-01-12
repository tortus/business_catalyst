# encoding: UTF-8

module BusinessCatalyst
  module CSV
    # URI encode a single String
    class URITransformer < Transformer

      def transform
        # Most modern method available in Ruby 1.8
        URI.encode(input) if input
      end

    end
  end
end
