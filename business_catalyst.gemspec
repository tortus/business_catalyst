# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'business_catalyst/version'

Gem::Specification.new do |spec|
  spec.name          = "business_catalyst"
  spec.version       = BusinessCatalyst::VERSION
  spec.authors       = ["Tortus Technologies"]
  spec.email         = ["support@tortus.com"]
  spec.description   = %q{Gem to help interface with Adobe Business Catalyst. Mainly for exporting product data to BC.}
  spec.summary       = %q{Gem to help interface with Adobe Business Catalyst. Mainly for exporting product data to BC.}
  spec.homepage      = "https://github.com/tortus/business_catalyst"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency "guard-rspec"
end
