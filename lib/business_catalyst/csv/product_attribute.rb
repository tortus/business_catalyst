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

  end
end
