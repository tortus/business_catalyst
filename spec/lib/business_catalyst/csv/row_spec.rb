# encoding: utf-8
require 'spec_helper'

describe BusinessCatalyst::CSV::Row do
  # Create a new subclass of Row for every example, so class method
  # stubs don't carry over between examples.
  let(:row_subclass) { Class.new(BusinessCatalyst::CSV::Row) }
  subject { row_subclass.new }

  describe "class methods" do
    subject { row_subclass }

    describe "#columns default implementation" do
      it "raises NotImplementedError" do
        expect { subject.columns }.to raise_error(NotImplementedError)
      end
    end

    describe "#headers" do
      it "returns an array of the first element of every column definition" do
        subject.stub(:columns) { [["Column Name", :method]] }
        subject.headers.should be_a(Array)
        subject.headers.should eq(["Column Name"])
      end
    end

    describe "#map(column)" do
      context "when column is not valid column name" do
        before { subject.stub(:columns) { [] } }
        it "raises NoSuchColumnError" do
          expect { subject.map(:name) }.to raise_error(::BusinessCatalyst::CSV::NoSuchColumnError)
        end
      end
      context "when column is a valid column name" do
        before { subject.stub(:columns) { [["Name", :name]] } }
        it "turns the provided block into a method of the same name" do
          subject.map(:name) { :test }
          subject.method_defined?(:name).should be_truthy
          subject.new.name.should eq(:test)
        end
      end
    end

  end

  describe "#csv_value(method, config)" do

    context "with valid config" do
      let(:header) { "Name" }
      let(:method) { :name }
      let(:default) { "default" }
      let(:transformer) { Class.new(::BusinessCatalyst::CSV::Transformer) }
      let(:config) { [header, method, default, transformer] }

      it "calls transformer.transform with result of #method and returns result" do
        subject.stub(method) { "some name" }
        transformer.should_receive(:transform).with("some name").and_return("new name")
        subject.csv_value(:name, config).should eq("new name")
      end

      context "when method is not implemented" do
        it "passes config[default] to transformer#transform" do
          transformer.should_receive(:transform).with(default).and_return("new name")
          subject.csv_value(:name, config).should eq("new name")
        end
      end

      context "when transformer is nil" do
        let(:config) { [header, method, default] }
        it "uses GenericTransformer" do
          ::BusinessCatalyst::CSV::GenericTransformer.should_receive(:transform).and_return("new name")
          subject.csv_value(:name, config).should eq("new name")
        end

        context "and default is nil" do
          let(:config) { [header, method] }
          it "uses nil as default" do
            ::BusinessCatalyst::CSV::GenericTransformer.should_receive(:transform).with(nil).and_return("new name")
            subject.csv_value(:name, config).should eq("new name")
          end
        end
      end
    end

    context "when config is nil" do
      context "when method is the name of a column" do
        before { subject.class.stub(:columns) { [["Name", :name, "default", ::BusinessCatalyst::CSV::GenericTransformer]] } }
        it "it looks up config from class.columns by method name" do
          subject.stub(:name) { "some name" }
          ::BusinessCatalyst::CSV::GenericTransformer.should_receive(:transform).with("some name").and_return("new name")
          subject.csv_value(:name).should eq("new name")
        end
      end
      context "when method is not the name of a column" do
        before { subject.class.stub(:columns) { [] } }
        it "raises NoSuchColumnError" do
          expect { subject.csv_value(:fubar, nil) }.to raise_error(::BusinessCatalyst::CSV::NoSuchColumnError)
        end
      end
    end
  end

  describe "#to_a" do
    it "maps csv_value for every column to an array" do
      subject.class.stub(:columns) { [["Product Code", :product_code]] }
      subject.should_receive(:csv_value).with(:product_code, ["Product Code", :product_code]).and_return("product_code")
      subject.to_a.should eq(["product_code"])
    end
  end

end
