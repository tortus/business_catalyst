# encoding: utf-8

module BusinessCatalyst
  module CSV
    # Abstract base class for transforming some input to a BC string.
    class Transformer

      attr_accessor :input

      def initialize(input)
        @input = input
      end

      def transform
        raise NotImplementedError, "Transformer subclasses must implement #transform"
      end

      def self.transform(input)
        new(input).transform
      end

    end
  end
end
