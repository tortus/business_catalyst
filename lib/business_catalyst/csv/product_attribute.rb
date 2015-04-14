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
        @display_as = self.class.normalize_display_as(value)
      end

      def options
        @options ||= []
      end

      def add_option(*args)
        if args.first.kind_of?(Option)
          option = args.first
        else
          name, image, price = *args
          option = Option.new(name, image, price)
        end
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
            add_option(name, image, price)

          elsif option.kind_of?(Array)
            name, image, price = *option
            add_option(name, image, price)

          elsif option.kind_of?(Option)
            add_option(option)

          else
            raise ArgumentError, "#{option} is not a valid ProductAttribute::Option"
          end
        end
      end

      # Convert display_as to integer for BC, raises ArgumentError
      # if input cannot be mapped to a valid integer. The following
      # symbols are accepted:
      #
      # * :dropdown = 5
      # * :checkbox = 6
      # * :radio    = 7
      def self.normalize_display_as(display_as)
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
