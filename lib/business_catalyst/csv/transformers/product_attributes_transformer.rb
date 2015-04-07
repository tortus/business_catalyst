# encoding: utf-8
module BusinessCatalyst
  module CSV

    # Example: Chain*|5|N:Rope Chain||US/0,Box Chain||US/5,Snake Chain||US/5;Length*|5|N:16 inch||US/0,18 inch||US/0,20 inch||US/0,24 inch||US/0
    #
    # Name1REQ|display_as|keep_stock:Option1.name|Option1.image|Option1.price,Option2.name|...;Name2...
    class ProductAttributesTransformer < Transformer

      def transform
        if input.kind_of?(String)
          input
        else
          attributes.map {|attribute|
            name        = BusinessCatalyst.sanitize_catalog_name(attribute.name)
            required    = attribute.required ? '*' : ''
            display_as  = attribute.display_as
            keep_stock  = BooleanTransformer.transform(attribute.keep_stock)

            text = ["#{name}#{required}", display_as, keep_stock].join("|")
            text << ":"

            text << attribute.options.map {|option|
              name  = BusinessCatalyst.sanitize_catalog_name(option.name.to_s)
              image = option.image.to_s
              price = CurrencyTransformer.transform(option.price)
              [name, image, price].join("|")
            }.join(",")

            text
          }.join(";")
        end
      end

      def attributes
        if input.kind_of?(Array)
          input
        else
          [input]
        end
      end

    end
  end
end
