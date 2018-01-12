# encoding: utf-8

module BusinessCatalyst
  module CSV
    # May be thrown by transformers on bad input.
    class InvalidInputError < StandardError
    end
  end
end
