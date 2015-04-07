# encoding: utf-8
require 'spec_helper'

module BusinessCatalyst
  module CSV
    describe ProductAttribute do
      it "raises ArgumentError when display_as is invalid symbol" do
        expect {
          ProductAttribute.new("Test", :invalid, false, false)
        }.to raise_error(ArgumentError)
      end
      it "raises ArgumentError when display_as is invalid integer" do
        expect {
          ProductAttribute.new("Test", -1, false, false)
        }.to raise_error(ArgumentError)
      end
    end
  end
end
