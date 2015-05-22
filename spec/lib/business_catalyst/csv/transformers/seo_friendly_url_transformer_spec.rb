# encoding: utf-8
require 'spec_helper'

module BusinessCatalyst
  module CSV

    describe SEOFriendlyUrlTransformer do
      subject { SEOFriendlyUrlTransformer }

      before do
        SEOFriendlyUrlTransformer.reset_global_urls
      end

      it "raises InvalidInputError with blank input" do
        expect { subject.new("") }.to raise_error(InvalidInputError)
      end

      it "raises InvalidInputError if duplicate URL's have been created" do
        a = subject.new("test")
        expect { subject.new("test") }.to raise_error(InvalidInputError)
      end

      describe "#transform" do
        it "returns input with no changes (for now)" do
          expect(subject.transform("test")).to eq("test")
        end
      end
    end

  end
end
