# encoding: utf-8
require 'spec_helper'

describe BusinessCatalyst do
  subject { BusinessCatalyst }

  describe "#seo_friendly_url" do
    it "replaces bad SEO chars with '-'" do
      subject.seo_friendly_url("a&b").should eq("a-b")
    end
    it "replaces multiple consecutive bad SEO chars with single '-'" do
      subject.seo_friendly_url("a/;&,#:\"|._@=?()b").should eq("a-b")
    end
    it "replaces whitespace with '-'" do
      subject.seo_friendly_url("a  b").should eq("a-b")
    end
    it "removes leading and trailing whitespace" do
      subject.seo_friendly_url(" a b \n").should eq("a-b")
    end
    it "removes leading and trailing '-'" do
      subject.seo_friendly_url("-a-b-").should eq("a-b")
    end
    it "squishes multiple consecutive '-'" do
      subject.seo_friendly_url("a--b").should eq("a-b")
    end
    it "downcases input" do
      subject.seo_friendly_url("A B").should eq("a-b")
    end
    it "strips random unicode characters" do
      subject.seo_friendly_url("test”®").should eq("test")
    end
  end

end
