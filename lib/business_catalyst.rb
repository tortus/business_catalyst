# encoding: utf-8
require "business_catalyst/version"
require "business_catalyst/csv/transformers"
require "business_catalyst/csv/row"
require "business_catalyst/csv/product_row"
require "business_catalyst/csv/catalog_row"

module BusinessCatalyst

  # Characters that will break a catalog import.
  CATALOG_CHAR_BLACKLIST = /[\/;&]/.freeze

  # Characters that won't cause an error but are bad for SEO.
  CATALOG_CHAR_GREYLIST = /[,#:"\|\._@=\?\(\)]/.freeze

  # Combination of blacklist and greylist
  ALL_BAD_SEO_CHARS = /[\/;&,#:"\|\._@=\?\(\)]/.freeze

  def self.sanitize_catalog_name(name, options = {})
    return name if name.nil?

    replace_with = options.fetch(:replace_with) { " " }
    escape_greylist = options.fetch(:escape_greylist) { false }
    ampersand_as = options.fetch(:ampersand_as) { "and" }
    squish = options.fetch(:squish) { true }

    sanitized = name.strip
    sanitized.gsub!("&", ampersand_as)
    sanitized.gsub!(CATALOG_CHAR_GREYLIST, replace_with) if escape_greylist
    sanitized.gsub!(CATALOG_CHAR_BLACKLIST, replace_with)
    sanitized.gsub!(/\s+/, " ") if squish
    sanitized
  end

  # A guess as to how business catalyst converts names to URL's. Simply removes all bad SEO chars,
  # downcases, and converts whitespace to '-'. Does NOT append numbers to ensure uniqueness, you
  # must do this yourself after conversion!
  def self.seo_friendly_url(name)
    name.strip.downcase.gsub(ALL_BAD_SEO_CHARS, "").gsub(/\s+/, "-").gsub(/-{2,}/, "-").gsub(/\A-+|-+\Z/, "")
  end

end
