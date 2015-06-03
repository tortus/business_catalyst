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

      it "returns nil for nil input" do
        expect(subject.transform(nil)).to eq(nil)
      end

      it "turns Attribute object graph into BC string" do
        chain = ProductAttribute.new("Chain", :display_as => 5, :required => false, :keep_stock => false)
        chain.add_option("Rope Chain", "image1", 5)
        expect(subject.transform(chain)).to eq("Chain|5|N:Rope Chain|image1|US/5")
      end

      it "appends '*' to required attribute names" do
        chain = ProductAttribute.new("Chain", :display_as => 5, :required => true, :keep_stock => false)
        chain.add_option("Rope Chain", "image1", 5)
        expect(subject.transform(chain)).to eq("Chain*|5|N:Rope Chain|image1|US/5")
      end

      it "joins multiple options with ','" do
        chain = ProductAttribute.new("Chain", :display_as => 5, :required => false, :keep_stock => false)
        chain.add_option("Rope Chain", "image1", 5)
        chain.add_option("Snake Chain", "image2", 5)
        expect(subject.transform(chain)).to eq("Chain|5|N:Rope Chain|image1|US/5,Snake Chain|image2|US/5")
      end

      it "joins multiple attributes with ';'" do
        chain = ProductAttribute.new("Chain", :display_as => 5, :required => false, :keep_stock => false)
        chain.add_option("Rope Chain", "image1", 5)
        length = ProductAttribute.new("Length", :display_as => 5, :required => true, :keep_stock => true)
        length.add_option("16 inch", "image2", 10)
        attributes = [chain, length]
        expect(subject.transform(attributes)).to eq("Chain|5|N:Rope Chain|image1|US/5;Length*|5|Y:16 inch|image2|US/10")
      end

      it "converts display_as value of :dropdown to 5" do
        chain = ProductAttribute.new("Chain", :display_as => :dropdown, :required => false, :keep_stock => false)
        chain.add_option("Rope Chain", "image1", 5)
        expect(subject.transform(chain)).to eq("Chain|5|N:Rope Chain|image1|US/5")
      end

      it "retains the double '|' around blank images" do
        chain = ProductAttribute.new("Chain", :display_as => :dropdown, :required => false, :keep_stock => false)
        chain.add_option("Rope Chain", nil, 5)
        expect(subject.transform(chain)).to eq("Chain|5|N:Rope Chain||US/5")
      end

      it "strips whitespace from around images" do
        chain = ProductAttribute.new("Chain", :display_as => :dropdown, :required => false, :keep_stock => false)
        chain.add_option("Rope Chain", " asdf ", 5)
        expect(subject.transform(chain)).to eq("Chain|5|N:Rope Chain|asdf|US/5")
      end

      it "strips whitespace from around names" do
        chain = ProductAttribute.new(" Chain ", :display_as => :dropdown, :required => false, :keep_stock => false)
        chain.add_option(" Rope Chain ", nil, 5)
        expect(subject.transform(chain)).to eq("Chain|5|N:Rope Chain||US/5")
      end

      it "does nothing to Strings" do
        expect(subject.transform("ASDF")).to eq("ASDF")
      end
    end
  end
end
