module BusinessCatalyst
  module CSV
    class CatalogRow < Row

      COLUMNS = [
        ["Catalog Name/Heirarchy", :catalog_name_hierarchy, nil, CatalogTransformer],
        ["Description", :description],
        ["Image", :image],
        ["Weighting", :weighting],
        ["Release Date", :release_date],
        ["Expiry Date", :expiration_date],
        ["Template ID", :template_id, 0, TemplateIDTransformer],
        ["Enabled", :enabled?, true, BooleanTransformer],
        ["Enable XML Feed", :enable_xml_feed?, false, BooleanTransformer],
        ["Show Product Prices", :show_product_prices?, true, BooleanTransformer],
        ["Catalog Title", :catalog_title],
        ["Browse Panel Min Price", :browse_panel_min_price, nil, CurrencyTransformer],
        ["Browse Panel Max Price", :browse_panel_max_price, nil, CurrencyTransformer],
        ["Browse Panel Slots", :browse_panel_min_slots],
        ["SEO Friendly URL", :seo_friendly_url] # Must be globally unique
      ]

      def self.columns
        COLUMNS
      end

    end
  end
end
