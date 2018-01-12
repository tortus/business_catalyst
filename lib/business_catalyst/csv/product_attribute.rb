# encoding: utf-8
module BusinessCatalyst
  module CSV

    # Usage:
    #
    #     # Option with custom image and price:
    #     size = BusinessCatalyst::CSV::ProductAttribute.new("Size", :display_as => :radio, :required => true, :keep_stock => false)
    #     size.add_option("Small", "live/url/for/small.jpg", "US/20.00")
    #     size.add_option("Large", "live/url/for/large.jpg", "US/25.00")
    #
    #     # Shorthand for multiple options with no image or price:
    #     color = BusinessCatalyst::CSV::ProductAttribute.new("Size", :display_as => :dropdown, :required => true, :keep_stock => false)
    #     color.add_options("Red", "Green", "Blue")
    #
    #     # Checkboxes:
    #     addon = BusinessCatalyst::CSV::ProductAttribute.new("Addon", :display_as => :checkbox, :required => false, :keep_stock => false)
    #     addon.add_option("Cool thing 1", nil, "US/5.00")
    #
    class ProductAttribute
      Option = Struct.new(:name, :image, :price)

      attr_accessor :name, :required, :keep_stock
      attr_reader :display_as

      def initialize(name, options = {})
        @name = name
        self.display_as = options.delete(:display_as) { nil }
        @required = options.delete(:required) { false }
        @keep_stock = options.delete(:keep_stock) { false }
        unless options.empty?
          raise ArgumentError, "unrecognized arguments: #{options.keys.inspect}"
        end
      end

      def display_as=(value)
        @display_as = self.class.normalize_display_as(value)
      end

      def options
        @options ||= []
      end

      # Usage:
      #
      #     # Simplest:
      #     add_option(name, image, price)
      #
      #     # Manually create ProductAttribute::Option instance:
      #     add_option(ProductAttribute::Option.new(name, image, price))
      #
      def add_option(*args)
        option = nil
        if args.length == 1
          arg = args.first
          if arg.kind_of?(Option)
            option = arg
          elsif arg.kind_of?(Hash)
            option = Option.new(arg.fetch(:name), arg.fetch(:image, nil), arg.fetch(:price, nil))
          else
            raise ArgumentError, "unrecognized argument: #{arg.inspect}"
          end
        else
          name, image, price = *args
          option = Option.new(name, image, price)
        end
        options << option
        option
      end

      # Usage:
      #
      #     # List of names:
      #     add_options("Name 1", "Name 2", ...)
      #
      #     # Arrays:
      #     add_options([name, image, price], [name, image, price], ...)
      #
      #     # Hashes:
      #     add_options({name: name, image: image, price: price}, ...)
      #
      #     # ProductAttribute::Option instances:
      #     option_1 = ProductAttribute::Option.new(name, image, price)
      #     add_options(option_1, ...)
      #
      def add_options(*args)
        if args.length > 1
          options = args.map {|arg| Array(arg)}
        elsif args.first.respond_to?(:each)
          options = args.first
        else
          raise ArgumentError, "options must be an Array of ProductAttribute::Option"
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
