source 'https://rubygems.org'

# Specify your gem's dependencies in business_catalyst.gemspec
gemspec

# Skip guard if we are on 1.8 (it won't work).
# Guard also needs to be in its own group so Travis won't waste time installing it.
if RUBY_VERSION != "1.8.7"
  group :guard do
    gem 'ruby_gntp'
    gem 'guard-rspec'
  end
end
