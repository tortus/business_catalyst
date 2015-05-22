# encoding: utf-8
module BusinessCatalyst
  module CSV

    class SEOFriendlyUrlTransformer < Transformer

      def initialize(input)
        input = input.to_s
        raise InvalidInputError, "seo_friendly_url must not be blank" if input.nil? || input.strip == ""
        raise InvalidInputError, "seo_friendly_url '#{input}' is not globally unique" unless self.class.is_globally_unique?(input)
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

      def self.is_globally_unique?(url)
        !global_urls.fetch(url, false)
      end

    end

  end
end
