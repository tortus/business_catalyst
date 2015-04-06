# encoding: utf-8
module BusinessCatalyst
  module CSV

    ProductAttribute = Struct.new(:name, :display_as, :required, :keep_stock) do
      Option = Struct.new(:name, :image, :price)

      def initialize(name, display_as = nil, required = false, keep_stock = false)
        display_as = normalize_display_as(display_as)
        super(name, display_as, required, keep_stock)
      end

      def display_as=(value)
        super(normalize_display_as(value))
      end

      def options
        @options ||= []
      end

      def add_option(name, image, price)
        option = Option.new(name, image, price)
        options << option
        option
      end

      private

      def normalize_display_as(display_as)
        if display_as.kind_of?(Symbol)
          case display_as
          when :dropdown
            5
          when :checkbox
            6
          when :radio
            7
          else
            raise ArgumentError, "display_as must be :dropdown, :checkbox, or :radio"
          end
        elsif ![5, 6, 7].include?(display_as)
          raise ArgumentError, "display_as must be 5, 6, or 7"
        else
          display_as
        end
      end

    end

    # Example: Chain*|5|N:Rope Chain||US/0,Box Chain||US/5,Snake Chain||US/5;Length*|5|N:16 inch||US/0,18 inch||US/0,20 inch||US/0,24 inch||US/0
    #
    # Name1REQ|display_as|keep_stock:Option1.name|Option1.image|Option1.price,Option2.name|...;Name2...
    class ProductAttributesTransformer < Transformer

      def transform
        attributes.map {|attribute|
          name        = attribute.name
          required    = attribute.required ? '*' : ''
          display_as  = convert_display_as(attribute.display_as)
          keep_stock  = BooleanTransformer.transform(attribute.keep_stock)

          text = ["#{name}#{required}", display_as, keep_stock].join("|")
          text << ":"

          text << attribute.options.map {|option|
            [ option.name.to_s, option.image.to_s, CurrencyTransformer.transform(option.price) ].join("|")
          }.join(",")

          text
        }.join(";")
      end

      def attributes
        if input.kind_of?(Array)
          input
        else
          [input]
        end
      end

      def convert_display_as(value)
        case value
        when :dropdown
          5
        when :checkbox
          6
        when :radio
          7
        else
          value.to_i
        end
      end

    end
  end
end
