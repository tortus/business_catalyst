require 'spec_helper'

describe BusinessCatalyst::Products::CSVRow do
  subject { BusinessCatalyst::Products::CSVRow.new }

  it "sets #default_currency to 'US'" do
    subject.default_currency.should eq("US")
  end

  describe "class methods" do
    subject { BusinessCatalyst::Products::CSVRow }

    describe "#columns" do
      it "returns an array of column definition arrays" do
        subject.columns.should be_a(Array)
        subject.columns.first.should eq(["Product Code", :product_code])
      end
    end

    describe "#headers" do
      it "returns an array of the first element of every column definition" do
        subject.headers.should be_a(Array)
        subject.headers.each_with_index do |header, index|
          header.should eq(subject.columns[index][0])
        end
      end
    end

    describe "#map(column)" do
      context "when column is not valid column name" do
        it "raises ArgumentError" do
          subject.columns.any? {|c| c[1] == :fubar}.should be_false
          expect { subject.map(:fubar) }.to raise_error(ArgumentError)
        end
      end
      context "when column is a valid column name" do
        it "turns the provided block into a method of the same name" do
          subject.method_defined?(:name).should be_false
          subject.map(:name) { :test }
          subject.method_defined?(:name).should be_true
          subject.new.name.should eq(:test)
        end
      end
    end

  end

  describe "#to_a" do
    it "maps csv_value for every column to an array" do
      subject.class.stub(:columns) { [["Product Code", :product_code]] }
      subject.should_receive(:csv_value).with(:product_code, nil).and_return("product_code")
      subject.to_a.should eq(["product_code"])
    end
  end

  describe "currency handling" do
    let(:currency_columns) { [:sale_price, :retail_price, :wholesale_sale_price] }
    let(:test_price) { 10.0 }
    before(:each) do
      subject.default_currency = "US"
      currency_columns.each do |column|
        subject.stub(column) { test_price }
      end
    end

    it "treats :sale_price, :retail_price, :wholesale_sale_price as currency" do
      currency_columns.each do |column|
        subject.should_receive(:number_to_currency).with(test_price).and_return("US/10.00")
        subject.csv_value(column).should eq("US/10.00")
      end
    end

    context "with single numeric" do
      it "converts the number to the BC format" do
        subject.csv_value(:sale_price).should eq("US/#{test_price.to_s}")
      end
      it "prepends #default_currency" do
        subject.default_currency = "AU"
        subject.csv_value(:sale_price).should eq("AU/#{test_price.to_s}")
      end
    end

    context "with single string" do
      it "does nothing if string looks like BC format already" do
        subject.stub(:sale_price) { "US/10.00" }
        subject.csv_value(:sale_price).should eq("US/10.00")
      end
      it "prepends #default_currency if no currency provided" do
        subject.stub(:sale_price) { "10.00" }
        subject.csv_value(:sale_price).should eq("US/10.00")
      end
      it "converts blank string to nil" do
        subject.stub(:sale_price) { " " }
        subject.csv_value(:sale_price).should be_nil
      end
      it "strips whitespace" do
        subject.stub(:sale_price) { " 2.0 " }
        subject.csv_value(:sale_price).should eq("US/2.0")
      end
    end

    context "with array of numbers" do
      it "converts each number to BC currency and joins with ';'" do
        subject.stub(:sale_price) { [1.0, 2.0, 3.0] }
        subject.csv_value(:sale_price).should eq("US/1.0;US/2.0;US/3.0")
      end
    end

    context "with array of numbers and strings" do
      it "converts each value as it would with single values, and joins with ';'" do
        subject.stub(:sale_price) { [1.0, " 2.0 ", " ", "US/3.0"] }
        subject.csv_value(:sale_price).should eq("US/1.0;US/2.0;US/3.0")
      end
    end
  end # currency handling

end
