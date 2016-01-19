# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'business_catalyst/version'

Gem::Specification.new do |spec|
  spec.name          = "business_catalyst"
  spec.version       = BusinessCatalyst::VERSION
  spec.authors       = ["Tortus Tek, Inc."]
  spec.email         = ["support@tortus.com"]
  spec.description   = %q{Libraries to help with exporting product data to BC.}
  spec.summary       = "business_catalyst-#{BusinessCatalyst::VERSION}"
  spec.homepage      = "https://github.com/tortus/business_catalyst"
  spec.license       = "MIT"
  spec.required_ruby_version = '>= 1.8.7'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10"
  spec.add_development_dependency "rspec", "~> 2.14"
end
