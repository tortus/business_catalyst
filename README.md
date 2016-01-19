# BusinessCatalyst

Tools for building CSV's for Adobe Business Catalyst e-commerce platform in Ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'business_catalyst', '~> 0.1.0'

And then execute:

    $ bundle

## Usage

Start with subclassing any of the provided Row classes:

* BusinessCatalyst::CSV::ProductRow
* BusinessCatalyst::CSV::CatalogRow

Then define methods to return values for the various BC columns.
Use the #map method to ensure correct naming. (In general, it is just the
underscored version of the BC column name, with '?' appended for
boolean columns. The COLUMNS constant in the base class has the complete
list, and I recommend referring to it extensively.)

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
CSV to 10000. However, you can get around this limit by importing multiple
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
3. Run tests:

    $ bundle install
    $ bundle exec rspec

4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
