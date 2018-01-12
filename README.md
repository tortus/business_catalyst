# BusinessCatalyst

![CI Status](https://travis-ci.org/tortus/business_catalyst.svg?branch=develop)

Tools for building CSV's for Adobe Business Catalyst e-commerce platform in Ruby. Use a Ruby DSL to turn your data into CSV's that can be imported in the BC admin. Supports product and catalog CSV's, and splitting large CSV's (over 10k products) into multiple files.

**Compatible with Ruby 1.8.7 and Ruby 2.3+.** Intended to be useful as a tool for migrating very old Rails sites, so we deliberately preserve Ruby 1.8 compatibility, even when it is a huge pain. Otherwise, we only maintain compatibility with the latest version because most sites that can run on 1.9 can be upgraded to 2.3 with **much** less effort.

## Installation

Add this line to your application's Gemfile:

    gem 'business_catalyst', '~> 0.1.1'

And then execute:

    $ bundle

## Usage

Start with subclassing any of the provided Row classes:

* (BusinessCatalyst::CSV::ProductRow)[lib/business_catalyst/csv/product_row.rb]
* (BusinessCatalyst::CSV::CatalogRow)[lib/business_catalyst/csv/catalog_row.rb]

Then define methods to return values for the various BC columns.
Use the #map method to ensure correct naming. (In general, it is just the
underscored version of the BC column name, with '?' appended for
boolean columns. __Refer to COLUMNS constant in the base class, or
https://github.com/tortus/business_catalyst/wiki for a complete list
of columns.__)

### Building a Product CSV

```ruby
class MyRow < BusinessCatalyst::CSV::ProductRow

  default_currency "US" # optional, US is already the default

  def initialize(product)
    @product = product
    super
  end

  map(:product_code) { @product.code }
  map(:name)         { @product.name }
  map(:catalog)      { ["Some", "Accessories"] }
  map(:enabled?)     { @product.active }
  map(:inventory_control?) { false }

  # ... (other properties here)
end

# Later, with a CSV opened for writing:

csv << MyRow.headers
products.each do |product|
  csv << MyRow.new(product).to_a
end
```

__Refer to https://github.com/tortus/business_catalyst/wiki for the complete list of columns.__

### Returning Ruby data types in your methods

In general, you can define your methods to return Ruby types such as Array,
Float (try to use BigDecimal or FixNum for currency though), True/False, etc.,
and the gem will turn it into the correct text for Business Catalyst for you,
and handle all escaping.

```ruby
# Array:
map(:catalog) { ["Value1", "Value2"] } # becomes: "Value1;Value2"

# Numeric:
map(:sell_price) { 10.0 } # becomes: "US/10.0"

# boolean:
map(:enabled?) { true } # becomes: "Y"
```

### If you have more than 10k product rows to import, use BusinessCatalyst::CSV::FileSplitter

Business Catalyst limits the number of products you can import in a single
CSV to 10,000. However, you can get around this limit by importing multiple
files. We have a class to help!

```ruby
# Simplest usage, assuming we already have some products to export:
splitter = BusinessCatalyst::CSV::FileSplitter.new("output_base_name.csv", header_row: MyRow.headers)
splitter.start do |splitter|
  product_rows.each do |row|
    splitter.start_row
    splitter.current_file << row.to_a
  end
end
```
See the class definition for all available options.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Run tests: ```bundle exec rspec spec```
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
