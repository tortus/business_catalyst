# encoding: utf-8
require "business_catalyst/version"
require "business_catalyst/csv/product_attribute"
require "business_catalyst/csv/transformers"
require "business_catalyst/csv/row"
require "business_catalyst/csv/product_row"
require "business_catalyst/csv/catalog_row"
require "business_catalyst/csv/file_splitter"

module BusinessCatalyst

  # The following characters cause an error message if they appear in a catalog name.
  CATALOG_CHAR_BLACKLIST = /[\\\/;#:"\|_@=\?]/.freeze
  MORE_STRICT_BLACKLIST = /[\\\/;&,#:"\|\._@=\?]/.freeze

  # Strip all characters out of a catalog name that will cause an error. Replaces them with
  # " " and then squishes all whitespace to single space to preserve word structure.
  def self.sanitize_catalog_name(name)
    return name if name.nil?
    sanitized = name.strip
    sanitized.gsub!(CATALOG_CHAR_BLACKLIST, " ")
    sanitized.gsub!(/\s+/, " ")
    sanitized
  end

  # A guess as to how business catalyst converts names to URL's, based on this blog entry:
  # http://www.businesscatalyst.com/bc-blog/seo-friendly-urls-for-products-and-catalogs
  #
  # Downcases, converts invalid characters and whitespace to '-', and finally removes multiple
  # consecutive dashes and leading and trailing dashes. Does NOT append
  # numbers to ensure uniqueness, you must do this yourself after conversion.
  def self.seo_friendly_url(name)
    name.strip.downcase.gsub(/[^a-z0-9\-]/, "-").gsub(/-{2,}/, "-").gsub(/\A-+|-+\Z/, "")
  end

  def self.reset_global_urls!
    BusinessCatalyst::CSV::SEOFriendlyUrlTransformer.reset_global_urls!
  end

end
