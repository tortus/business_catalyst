# encoding: utf-8
require 'spec_helper'

module BusinessCatalyst
  module CSV
    describe ProductAttribute do

      describe "#new" do
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

      describe "add_options([...])" do
        it "calls add_option with the splat of each array item" do
          attribute = ProductAttribute.new("Test", :dropdown, false, false)
          attribute.add_options([["Opt", "img", 1]])
          expect(attribute.options).to eq([ProductAttribute::Option.new("Opt", "img", 1)])
        end
        it "coerces arguments to array" do
          attribute = ProductAttribute.new("Test", :dropdown, false, false)
          attribute.add_options(["Opt1", "img", 1], ["Opt2", "img", 1])
          expect(attribute.options).to eq([
            ProductAttribute::Option.new("Opt1", "img", 1),
            ProductAttribute::Option.new("Opt2", "img", 1)
          ])
        end
        it "handles hashes correctly" do
          attribute = ProductAttribute.new("Test", :dropdown, false, false)
          attribute.add_options([{:name => "Opt1", :image => "img", :price => 1}])
          expect(attribute.options).to eq([ProductAttribute::Option.new("Opt1", "img", 1)])
        end
        it "does nothing to raw ProductAttribute::Option objects" do
          attribute = ProductAttribute.new("Test", :dropdown, false, false)
          attribute.add_options([ProductAttribute::Option.new("Opt1", "img", 1)])
          expect(attribute.options).to eq([ProductAttribute::Option.new("Opt1", "img", 1)])
        end
      end

    end
  end
end
