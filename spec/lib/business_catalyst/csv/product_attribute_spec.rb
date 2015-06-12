# encoding: utf-8
require 'spec_helper'

module BusinessCatalyst
  module CSV
    describe ProductAttribute do

      describe "#new" do
        it "raises ArgumentError when display_as is invalid symbol" do
          expect {
            ProductAttribute.new("Test", :display_as => :invalid, :required => false, :keep_stock => false)
          }.to raise_error(ArgumentError)
        end
        it "raises ArgumentError when display_as is invalid integer" do
          expect {
            ProductAttribute.new("Test", :display_as => -1)
          }.to raise_error(ArgumentError)
        end
      end

      describe "#add_options" do
        context "when given an Array of Arrays" do
          it "calls add_option with the splat of each array item" do
            attribute = ProductAttribute.new("Test", :display_as => :dropdown, :required => false, :keep_stock => false)
            attribute.add_options([["Opt", "img", 1]])
            expect(attribute.options).to eq([ProductAttribute::Option.new("Opt", "img", 1)])
          end
          it "coerces arguments to array" do
            attribute = ProductAttribute.new("Test", :display_as => :dropdown, :required => false, :keep_stock => false)
            attribute.add_options(["Opt1", "img", 1], ["Opt2", "img", 1])
            expect(attribute.options).to eq([
              ProductAttribute::Option.new("Opt1", "img", 1),
              ProductAttribute::Option.new("Opt2", "img", 1)
            ])
          end
        end
        context "when given an Array of Hashes" do
          it "handles hashes correctly" do
            attribute = ProductAttribute.new("Test", :display_as => :dropdown, :required => false, :keep_stock => false)
            attribute.add_options([{:name => "Opt1", :image => "img", :price => 1}])
            expect(attribute.options).to eq([ProductAttribute::Option.new("Opt1", "img", 1)])
          end
        end
        context "when given an Array of ProductAttribute::Option instances" do
          it "adds just appends the object(s) to #options" do
            attribute = ProductAttribute.new("Test", :display_as => :dropdown, :required => false, :keep_stock => false)
            attribute.add_options([ProductAttribute::Option.new("Opt1", "img", 1)])
            expect(attribute.options).to eq([ProductAttribute::Option.new("Opt1", "img", 1)])
          end
        end
        context "when given several strings" do
          it "it turns each into an option with a name only" do
            attribute = ProductAttribute.new("Test", :display_as => :dropdown, :required => false, :keep_stock => false)
            attribute.add_options("Opt1", "Opt2")
            expect(attribute.options).to eq([
              ProductAttribute::Option.new("Opt1", nil, nil),
              ProductAttribute::Option.new("Opt2", nil, nil)
            ])
          end
        end
      end

    end
  end
end
