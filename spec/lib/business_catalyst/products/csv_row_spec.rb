require 'spec_helper'

describe BusinessCatalyst::Products::CSVRow do
  subject { BusinessCatalyst::Products::CSVRow.new }

  it "sets #default_currency to 'US'" do
    subject.default_currency.should eq("US")
  end
end
