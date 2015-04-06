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
end
