# encoding: utf-8
module BusinessCatalyst
  module Products

    # Subclass and override the methods for columns
    # you need to export. You may return arrays for certain
    # columns that take multiple values, like catalogue,
    # and true/false for boolean columns.
    #
    # nil will always be interpreted as blank.
    #
    # == What method name to use?
    #
    # Refer to the COLUMNS constant, but in general use the
    # underscored name of the column, with slashes replaced by 'or',
    # and '?' appended to columns that expect a boolean.
    #
    # == Example
    #
    #   class ExportRow < BusinessCatalyst::Products::CSVRow
    #
    #     def initialize(product)
    #       @product = product
    #       super
    #     end
    #
    #     map :product_code do
    #       @product.code
    #     end
    #
    #     map :inventory_control? do
    #       false
    #     end
    #
    #     # ... (other properties here)
    #   end
    #
    # Later, with a CSV opened for writing:
    #
    #   some_csv << ExportRow.headers
    #   some_csv << row_instance.to_a
    #
    class CSVRow

      attr_accessor :default_currency

      def initialize(*args)
        @default_currency ||= "US"
      end

      # Way of implementing BC properties and making sure you get the name right.
      # Has added benefit of making it easier to differentiate between
      # instance methods and instance methods that map to BC columns.
      def self.map(column, &block)
        unless columns.any? {|c| c[1] == column}
          raise ArgumentError, "no such column '#{column}'"
        end
        define_method(column, &block)
      end

      def to_a
        self.class.columns.map { |column|
          _, method, default = *column
          csv_value(method, default)
        }
      end

      def self.headers
        @headers ||= columns.map(&:first)
      end

      def self.columns
        COLUMNS
      end

      # [Header, method, default (optional)]
      COLUMNS = [
        ["Product Code", :product_code],
        ["Name", :name],
        ["Description", :description],
        ["Small Image", :small_image],
        ["Large Image", :large_image],
        ["Catalogue", :catalogue, []], # Can be an array of path names, or an array of arrays of path names (multiple catalogs)
        ["Sell Price", :sell_price],
        ["Recommended Retail Price", :recommended_retail_price],
        ["Tax Code", :tax_code],
        ["SEO friendly URL", :seo_friendly_url],
        ["Grouping Product Codes", :grouping_product_codes],
        ["Grouping Product Descriptions", :grouping_product_descriptions],
        ["Supplier CRM ID", :supplier_crm_id],
        ["Supplier Commission Percentage", :supplier_commission_percentage],
        ["Weighting/Order", :weighting_order],
        ["Related Products", :related_products, []],
        ["Weight In KG/Pounds", :weight_in_kg_or_pounds],
        ["Product Width (Previously Volume)", :product_width],
        ["Keywords", :keywords],
        ["Unit Type", :unit_type],
        ["Min Units", :min_units],
        ["Max Units", :max_units],
        ["In Stock", :in_stock],
        ["On Order", :on_order],
        ["Re-order Threshold", :re_order_threshold],
        ["Inventory Control", :inventory_control?, false],
        ["Can Pre-Order", :can_pre_order?, false],
        ["Custom 1", :custom_1],
        ["Custom 2", :custom_2],
        ["Custom 3", :custom_3],
        ["Custom 4", :custom_4],
        ["Poplets", :poplets],
        ["Enabled", :enabled?, true],
        ["Capture Details", :capture_details?, false],
        ["Limit Download Count", :limit_download_count],
        ["Limit Download IP", :limit_download_ip],
        ["On Sale", :on_sale?, false],
        ["Hide if Out of Stock", :hide_if_out_of_stock?, false],
        ["Attributes", :attributes],
        ["Gift Voucher", :gift_voucher?, false],
        ["Drop Shipping", :drop_shipping?, false],
        ["Product Height", :product_height],
        ["Product Depth", :product_depth],
        ["Exclude From Search Results", :exclude_from_search_results?, false],
        ["Product Title", :product_title],
        ["Wholesale Sale Price", :wholesale_sale_price],
        ["Tax Code", :tax_code],
        ["Cycle Type", :cycle_type],
        ["Cycle Type Count", :cycle_type_count],
        ["Product URL", :product_url],
        ["Product Affiliate URL", :product_affiliate_url],
        ["Variations Enabled", :variations_enabled?, false],
        ["Variations Code", :variations_code],
        ["Variation Options", :variations_options],
        ["Role Responsible", :role_responsible],
        ["Product Meta Description", :product_meta_description]
      ]

      # Get the final CSV output for a column.
      # Uses default if method is not implemented, then
      # normalizes value to whatever is expected by BC.
      def csv_value(method, default = nil)
        input = if respond_to?(method)
                  send(method)
                else
                  default
                end
        transformer = ("transform_" + method.to_s.sub(/\?\z/, "")).to_sym
        if methods.map{|m| m.to_sym}.include?(transformer)
          send(transformer, input)
        elsif method.to_s[-1] == "?"
          transform_boolean(input)
        else
          transform_generic_input(input)
        end
      end

      protected

        def transform_generic_input(input)
          case input
          when true, false
            transform_boolean(input)
          when Array
            input.join(";")
          else
            input.to_s
          end
        end

        def transform_boolean(input)
          input ? "Y" : "N"
        end

        def transform_catalogue(input)
          input = [input] unless input.kind_of?(Array) # ensure at least a 1D array

          # convert to array of arrays if not already
          unless input.fetch(0, nil).kind_of?(Array)
            input = [input]
          end

          input.map { |catalog_names|
            sanitized_names = catalog_names.map { |name|
              name.gsub(/[\/;]/, " ").gsub(/\s+/, " ")
            }
            "/" + sanitized_names.join("/")
          }.join(";")
        end

        # Convert a single number or string to the currency format
        # expected by business catalyst, e.g. "10.23" becomes "US/10.23"
        #
        # Does nothing if the input is already a string in this format.
        #
        # Returns nil if input is blank or can't be converted.
        #
        # The default currency may be changed by setting #default_currency=
        # in #initialize.
        def number_to_currency(input)
          if input && (input_s = input.to_s.strip) != ""
            if input_s =~ /\A\w+\/\d/
              input_s
            else
              "#{default_currency}/#{input_s}"
            end
          end
        end

        def transform_currency(input)
          if input
            inputs = Array(input).map {|n| number_to_currency(n) }.compact
            if inputs.any?
              inputs.join(";")
            end
          end
        end

        [:sale_price, :retail_price, :wholesale_sale_price].each do |currency_column|
          define_method("transform_#{currency_column}") do |input|
            transform_currency(input)
          end
        end

    end
  end
end
