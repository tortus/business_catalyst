# encoding: utf-8

module BusinessCatalyst
  module CSV
    # When defining an SEO-friendly URL, it will have a number appended to it
    # if it is not globally unique. This transformer checks for uniqueness
    # of the input. It does NOT perform any conversion.
    class SEOFriendlyUrlTransformer < Transformer

      def initialize(input)
        input = input.to_s
        if input.nil? || input.strip == ""
          raise InvalidInputError, "seo_friendly_url must not be blank"
        end
        unless self.class.globally_unique?(input)
          raise InvalidInputError, "seo_friendly_url '#{input}' is not globally unique"
        end
        self.class.register_url(input)
        super(input)
      end

      def transform
        input
      end

      def self.reset_global_urls!
        @global_urls = {}
      end

      def self.global_urls
        @global_urls ||= {}
      end

      def self.register_url(url)
        global_urls[url] = true
      end

      def self.globally_unique?(url)
        !global_urls.fetch(url, false)
      end

    end
  end
end
