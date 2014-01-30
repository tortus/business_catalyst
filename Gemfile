source 'https://rubygems.org'

# Specify your gem's dependencies in business_catalyst.gemspec
gemspec

# skip guard if we are on 1.8 (it won't work)
if RUBY_VERSION != "1.8.7"
  group :guard do
    gem 'ruby_gntp'
    gem 'guard-rspec'
  end
end
