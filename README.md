# BusinessCatalyst

Tools for building CSV's for Adobe Business Catalyst e-commerce platform in Ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'business_catalyst', :github => 'tortus/business_catalyst'

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
