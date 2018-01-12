# encoding: utf-8

module BusinessCatalyst
  module CSV
    # Encode one or more URI's. BC will not do the right thing
    # if you import a URI with a space in it. This does the
    # "%20" stuff in advance.
    class URIArrayTransformer < Transformer

      def transform
        return nil unless input

        Array(input).map do |s|
          # More modern methods are not available in Ruby 1.8
          URI.encode(s.to_s).gsub(";", " ")
        end.join(";")
      end

    end
  end
end
