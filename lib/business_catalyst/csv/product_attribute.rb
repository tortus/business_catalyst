# encoding: utf-8
module BusinessCatalyst
  module CSV

    class ProductAttribute
      Option = Struct.new(:name, :image, :price)

      attr_accessor :name, :display_as, :required, :keep_stock

      def initialize(name, display_as = nil, required = false, keep_stock = false)
        @name = name
        self.display_as = display_as
        @required = required
        @keep_stock = keep_stock
      end

      def display_as=(value)
        @display_as = normalize_display_as(value)
      end

      def options
        @options ||= []
      end

      def add_option(name, image, price)
        option = Option.new(name, image, price)
        options << option
        option
      end

      def add_options(*args)
        if args.length > 1
          options = args
        else
          options = args.first
        end
        options.each do |option|
          if option.kind_of?(Hash)
            name = option.fetch(:name)
            image = option.fetch(:image, nil)
            price = option.fetch(:price, nil)
          else
            name, image, price = *option
          end
          add_option(name, image, price)
        end
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

  end
end
