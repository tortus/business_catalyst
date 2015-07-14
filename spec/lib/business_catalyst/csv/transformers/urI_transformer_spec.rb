# encoding: utf-8
require 'spec_helper'

module BusinessCatalyst::CSV
  describe URITransformer do
    subject { URITransformer }

    it "does nothing to normal image paths" do
      expect(subject.transform("/images/test.png")).to eq("/images/test.png")
    end

    it "URI encodes input" do
      expect(subject.transform("test#2.png")).to eq("test%232.png")
    end

  end
end
