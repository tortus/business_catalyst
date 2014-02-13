require 'spec_helper'

describe BusinessCatalyst do
  subject { BusinessCatalyst }

  describe "#name_to_url" do
    it "replaces all bad SEO chars with empty string" do
      subject.name_to_url("/;&,#:\"|._@=?()").should eq("")
    end
    it "replaces whitespace with '-'" do
      subject.name_to_url("a  b").should eq("a-b")
    end
    it "removes leading and trailing whitespace" do
      subject.name_to_url(" a b \n").should eq("a-b")
    end
    it "removes leading and trailing '-'" do
      subject.name_to_url("-a-b-").should eq("a-b")
    end
    it "squishes multiple consecutive '-'" do
      subject.name_to_url("a--b").should eq("a-b")
    end
    it "downcases input" do
      subject.name_to_url("A B").should eq("a-b")
    end
  end

end
