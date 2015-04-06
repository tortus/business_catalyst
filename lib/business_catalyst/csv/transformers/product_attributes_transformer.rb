# encoding: utf-8
module BusinessCatalyst
  module CSV

    Attribute = Struct.new(:name, :display_as, :required, :keep_stock) do

      Option = Struct.new(:name, :image, :price)

      def options
        @options ||= []
      end

      def add_option(name, image, price)
        option = Option.new(name, image, price)
        options << option
        option
      end

    end

    # Example: Chain*|5|N:Rope Chain||US/0,Box Chain||US/5,Snake Chain||US/5;Length*|5|N:16 inch||US/0,18 inch||US/0,20 inch||US/0,24 inch||US/0
    #
    # Name1REQ|display_as|keep_stock:Option1.name|Option1.image|Option1.price,Option2.name|...;Name2...
    class ProductAttributesTransformer < Transformer

      def attributes
        if input.kind_of?(Array)
          input
        else
          [input]
        end
      end

      def transform
        attributes.map {|attribute|
          name        = attribute.name
          required    = attribute.required ? '*' : ''
          display_as  = attribute.display_as
          keep_stock  = BooleanTransformer.transform(attribute.keep_stock)

          text = ["#{name}#{required}", display_as, keep_stock].join("|")
          text << ":"

          text << attribute.options.map {|option|
            [ option.name.to_s, option.image.to_s, CurrencyTransformer.transform(option.price) ].join("|")
          }.join(",")

          text
        }.join(";")
      end

    end
  end
end
