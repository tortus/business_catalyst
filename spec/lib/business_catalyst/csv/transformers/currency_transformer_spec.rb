# encoding: utf-8
require 'spec_helper'

module BusinessCatalyst
  module CSV

    describe CurrencyTransformer do
      subject { CurrencyTransformer }
      # reset default_currency before every example since it is a class var
      before { CurrencyTransformer.default_currency = nil }

      describe "CurrencyTransformer.default_currency" do
        it "defaults to 'US'" do
          subject.default_currency.should eq("US")
        end
      end

      context "with single numeric" do
        it "converts the number to the BC format" do
          input = 10.0
          subject.transform(input).should eq("US/#{input.to_s}")
        end
        it "prepends CurrencyTransformer.default_currency" do
          input = 10.0
          subject.default_currency = "AU"
          subject.transform(input).should eq("AU/#{input.to_s}")
        end
      end

      context "with single string" do
        it "does nothing if string looks like BC format already" do
          subject.transform("US/10.00").should eq("US/10.00")
        end
        it "prepends #default_currency if no currency provided" do
          subject.transform("10.00").should eq("US/10.00")
        end
        it "converts blank string to nil" do
          subject.transform(" ").should be_nil
        end
        it "strips whitespace" do
          subject.transform(" 2.0 ").should eq("US/2.0")
        end
      end

      context "with array of numbers" do
        it "converts each number to BC currency and joins with ';'" do
          subject.transform( [1.0, 2.0, 3.0] ).should eq("US/1.0;US/2.0;US/3.0")
        end
      end

      context "with array of numbers and strings" do
        it "converts each value as it would with single values, and joins with ';'" do
          subject.transform( [1.0, " 2.0 ", " ", "AU/3.0"] ).should eq("US/1.0;US/2.0;AU/3.0")
        end
      end

      context "with a BigDecimal" do
        it "converts input to floating point string, not default sci notation" do
          expect(subject.transform(BigDecimal.new("1234.56"))).to eq("US/1234.56")
        end
      end
    end

  end
end
