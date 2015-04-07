# encoding: utf-8
require 'spec_helper'

module BusinessCatalyst
  module CSV

    # Example: Chain*|5|N:Rope Chain||US/0,Box Chain||US/5,Snake Chain||US/5;Length*|5|N:16 inch||US/0,18 inch||US/0,20 inch||US/0,24 inch||US/0
    describe ProductAttributesTransformer do
      subject { ProductAttributesTransformer }

      before(:each) do
        CurrencyTransformer.default_currency = "US"
      end

      it "turns Attribute object graph into BC string" do
        chain = ProductAttribute.new("Chain", 5, false, false)
        chain.add_option("Rope Chain", "image1", 5)
        expect(subject.transform(chain)).to eq("Chain|5|N:Rope Chain|image1|US/5")
      end

      it "appends '*' to required attribute names" do
        chain = ProductAttribute.new("Chain", 5, true, false)
        chain.add_option("Rope Chain", "image1", 5)
        expect(subject.transform(chain)).to eq("Chain*|5|N:Rope Chain|image1|US/5")
      end

      it "joins multiple options with ','" do
        chain = ProductAttribute.new("Chain", 5, false, false)
        chain.add_option("Rope Chain", "image1", 5)
        chain.add_option("Snake Chain", "image2", 5)
        expect(subject.transform(chain)).to eq("Chain|5|N:Rope Chain|image1|US/5,Snake Chain|image2|US/5")
      end

      it "joins multiple attributes with ';'" do
        chain = ProductAttribute.new("Chain", 5, false, false)
        chain.add_option("Rope Chain", "image1", 5)
        length = ProductAttribute.new("Length", 5, true, true)
        length.add_option("16 inch", "image2", 10)
        attributes = [chain, length]
        expect(subject.transform(attributes)).to eq("Chain|5|N:Rope Chain|image1|US/5;Length*|5|Y:16 inch|image2|US/10")
      end

      it "converts display_as value of :dropdown to 5" do
        chain = ProductAttribute.new("Chain", :dropdown, false, false)
        chain.add_option("Rope Chain", "image1", 5)
        expect(subject.transform(chain)).to eq("Chain|5|N:Rope Chain|image1|US/5")
      end
    end
  end
end
