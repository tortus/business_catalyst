# encoding: utf-8
require 'spec_helper'

module BusinessCatalyst
  module CSV

    describe CatalogTransformer do
      subject { CatalogTransformer }
      it "prepends and joins catalogs with '/'" do
        subject.transform(["A", "B"]).should eq("/A/B")
      end
      it "joins multiple categorizations with ';'" do
        subject.transform( [["A", "B"], ["C", "D"]] ).should eq("/A/B;/C/D")
      end
      it "treats a single string as one catalog" do
        subject.transform("A").should eq("/A")
      end
      it "replaces slashes with a space" do
        subject.transform("One/Two").should eq("/One Two")
      end
      it "replaces semi-colons with a space" do
        subject.transform("One;Two").should eq("/One Two")
      end
      it "squishes multiple spaces" do
        subject.transform("A  B").should eq("/A B")
      end
      it "converts all whitespace characters to single space" do
        subject.transform("A\n\nB").should eq("/A B")
      end
    end

  end
end
