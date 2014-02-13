require 'spec_helper'

describe BusinessCatalyst do
  subject { BusinessCatalyst }

  describe "#seo_friendly_url" do
    it "replaces all bad SEO chars with empty string" do
      subject.seo_friendly_url("/;&,#:\"|._@=?()").should eq("")
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
  end

end
