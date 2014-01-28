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
end
