# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stacker_bee/version'

Gem::Specification.new do |spec|
  spec.name          = "stacker_bee"
  spec.version       = StackerBee::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Greg Sterndale", "Mike Nicholaides"]
  spec.email         = ["team@promptworks.com"]
  spec.summary       = %q{Ruby CloudStack client}
  spec.description   = %q{Ruby CloudStack client and CLI}
  spec.homepage      = "http://github.com/promptworks/stacker_bee"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday",            "~> 0.8"
  # this is a dependency for FaradayMiddleware::Graylog
  spec.add_runtime_dependency "faraday_middleware", "~> 0.9"
  spec.add_runtime_dependency "rash",               "~> 0.4"
  spec.add_runtime_dependency 'multi_json',         "~> 1.8"

  spec.add_development_dependency "bundler",  "~> 1.3"
  spec.add_development_dependency "rake",     "~> 10.0"
  spec.add_development_dependency "rspec",    "~> 2.1"
  spec.add_development_dependency "webmock",  "~> 1.15"
  spec.add_development_dependency "vcr",      "~> 2.6"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "pry"
end
