# encoding: utf-8
require 'spec_helper'

module BusinessCatalyst::CSV

  describe Transformer do
    subject { Transformer.new("input") }

    describe "#transform" do
      it "raises NotImplementedError" do
        expect { subject.transform }.to raise_error(NotImplementedError)
      end
    end

    describe "Transformer.transform(input)" do
      it "creates a new instance with input" do
        Transformer.should_receive(:new).with("input").and_return(double("Transformer").as_null_object)
        Transformer.transform("input")
      end
      it "calls transform on the instance" do
        Transformer.any_instance.should_receive(:transform).and_return(:output)
        Transformer.transform(:input).should eq(:output)
      end
    end
  end

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
    it "converts & to 'and'" do
      subject.transform("A & B").should eq("/A and B")
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

end
