# encoding: utf-8
require 'spec_helper'

module BusinessCatalyst::CSV

  describe GenericTransformer do
    subject { GenericTransformer }
    it "calls to_s on input" do
      input = double("some input")
      input.should_receive(:to_s).and_return("string value")
      subject.transform(input).should eq("string value")
    end
    it "leaves nil alone" do
      subject.transform(nil).should be_nil
    end
  end

  describe ArrayTransformer do
    subject { ArrayTransformer }
    it "joins input with ';'" do
      subject.transform(["A", "B"]).should eq("A;B")
    end
    it "escapes semi-colons by converting to spaces" do
      subject.transform(["A;B", "C"]).should eq("A B;C")
    end
    it "returns nil when input is nil" do
      subject.transform(nil).should be_nil
    end
  end

  describe BooleanTransformer do
    subject { BooleanTransformer }
    it "converts true to 'Y'" do
      subject.transform(true).should eq("Y")
    end
    it "converts false to 'N'" do
      subject.transform(false).should eq("N")
    end
    it "converts nil to 'N'" do
      subject.transform(nil).should eq("N")
    end
  end

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
  end

  describe TemplateIDTransformer do
    subject { TemplateIDTransformer }

    context "with symbol" do
      it "converts :default to 0" do
        subject.transform(:default).should eq(0)
      end
      it "converts :none to -1" do
        subject.transform(:none).should eq(-1)
      end
      it "converts :parent to -2" do
        subject.transform(:parent).should eq(-2)
      end
      it "raises an error for any symbol other than :none and :parent" do
        expect { subject.transform(:test) }.to raise_error(InvalidInputError)
      end
    end

    context "with string" do
      it "does nothing" do
        subject.transform("1234").should eq("1234")
      end
    end

    context "with integer" do
      it "does nothing" do
        subject.transform(1234).should eq(1234)
      end
    end
  end

end
