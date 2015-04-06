# encoding: utf-8
module BusinessCatalyst
  module CSV

    # Subclass and call #map to set values for columns. You may return
    # arrays for columns that take multiple values, like catalog,
    # and true/false for boolean columns.
    #
    # nil will always be interpreted as blank.
    #
    # == What method name to use?
    #
    # Refer to the COLUMNS constant, but in general use the
    # underscored name of the column, with '?' appended to columns
    # that expect a boolean.
    #
    # == Example
    #
    #   class MyRow < BusinessCatalyst::CSV::ProductRow
    #
    #     def initialize(product)
    #       @product = product
    #       super
    #     end
    #
    #     map(:product_code) { @product.code }
    #     map(:name)         { @product.name }
    #     map(:catalog)      { ["Some", "Accessories"] }
    #     map(:enabled?)     { @product.active }
    #     map(:inventory_control?) { false }
    #
    #     # ... (other properties here)
    #   end
    #
    # Later, with a CSV opened for writing:
    #
    #   csv << MyRow.headers
    #   products.each do |product|
    #     csv << MyRow.new(product).to_a
    #   end
    #
    class ProductRow < Row

      def self.columns
        COLUMNS
      end

      # [Header, method, default, transformer]
      COLUMNS = [
        ["Product Code", :product_code],
        ["Name", :name],
        ["Description", :description],
        ["Small Image", :small_image],
        ["Large Image", :large_image],
        ["Catalog", :catalog, [], CatalogTransformer], # Can be an array of path names, or an array of arrays of path names (multiple catalogs)
        ["Sell Price", :sell_price, nil, CurrencyTransformer],
        ["Recommended Retail Price", :recommended_retail_price, nil, CurrencyTransformer],
        ["Tax Code", :tax_code],
        ["SEO friendly URL", :seo_friendly_url],
        ["Grouping Product Codes", :grouping_product_codes, nil, ArrayTransformer],
        ["Grouping Product Descriptions", :grouping_product_descriptions, nil, ArrayTransformer],
        ["Supplier CRM ID", :supplier_crm_id],
        ["Supplier Commission Percentage", :supplier_commission_percentage],
        ["Weighting/Order", :weighting_order],
        ["Related Products", :related_products, [], ArrayTransformer],
        ["Weight In KG/Pounds", :weight_in_kg_or_pounds],
        ["Product Width (Previously Volume)", :product_width],
        ["Keywords", :keywords],
        ["Unit Type", :unit_type],
        ["Min Units", :min_units],
        ["Max Units", :max_units],
        ["In Stock", :in_stock],
        ["On Order", :on_order],
        ["Re-order Threshold", :re_order_threshold],
        ["Inventory Control", :inventory_control?, false, BooleanTransformer],
        ["Can Pre-Order", :can_pre_order?, false, BooleanTransformer],
        ["Custom 1", :custom_1],
        ["Custom 2", :custom_2],
        ["Custom 3", :custom_3],
        ["Custom 4", :custom_4],
        ["Poplets", :poplets, [], ArrayTransformer],
        ["Enabled", :enabled?, true, BooleanTransformer],
        ["Capture Details", :capture_details?, false, BooleanTransformer],
        ["Limit Download Count", :limit_download_count],
        ["Limit Download IP", :limit_download_ip],
        ["On Sale", :on_sale?, false, BooleanTransformer],
        ["Hide if Out of Stock", :hide_if_out_of_stock?, false, BooleanTransformer],
        ["Attributes", :attributes, nil, ProductAttributesTransformer],
        ["Gift Voucher", :gift_voucher?, false, BooleanTransformer],
        ["Drop Shipping", :drop_shipping?, false, BooleanTransformer],
        ["Product Height", :product_height],
        ["Product Depth", :product_depth],
        ["Exclude From Search Results", :exclude_from_search_results?, false, BooleanTransformer],
        ["Product Title", :product_title],
        ["Wholesale Sale Price", :wholesale_sale_price, nil, CurrencyTransformer],
        ["Tax Code", :tax_code],
        ["Cycle Type", :cycle_type],
        ["Cycle Type Count", :cycle_type_count],
        ["Product URL", :product_url],
        ["Product Affiliate URL", :product_affiliate_url],
        ["Variations Enabled", :variations_enabled?, false, BooleanTransformer],
        ["Variations Code", :variations_code],
        ["Variation Options", :variations_options],
        ["Role Responsible", :role_responsible],
        ["Product Meta Description", :product_meta_description]
      ]

    end
  end
end
