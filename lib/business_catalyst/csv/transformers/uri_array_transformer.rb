# encoding: utf-8

module BusinessCatalyst
  module CSV
    class URIArrayTransformer < Transformer

      def transform
        if input
          Array(input).map {|s| URI.encode(s.to_s).gsub(";", " ") }.join(";")
        end
      end

    end
  end
end
