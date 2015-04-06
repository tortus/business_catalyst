# encoding: utf-8
module BusinessCatalyst
  module CSV

    class InvalidInputError < StandardError
    end


    class Transformer
      attr_accessor :input

      def initialize(input)
        @input = input
      end

      def transform
        raise NotImplementedError, "Transformer subclasses must implement #transform"
      end

      def self.transform(input)
        self.new(input).transform
      end
    end

  end
end
