lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stacker_bee/version'

Gem::Specification.new do |spec|
  spec.name          = 'stacker_bee'
  spec.version       = StackerBee::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Greg Sterndale', 'Mike Nicholaides']
  spec.email         = ['team@promptworks.com']
  spec.summary       = 'Ruby CloudStack client'
  spec.description   = 'Ruby CloudStack client and CLI'
  spec.homepage      = 'http://github.com/promptworks/stacker_bee'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'faraday',    '~> 0.8', '< 0.9'
  spec.add_runtime_dependency 'multi_json', '~> 1.8'

  # this is a dependency for FaradayMiddleware::Graylog
  spec.add_runtime_dependency 'faraday_middleware', '~> 0.9'

  spec.add_development_dependency 'bundler',   '~> 1.3'
  spec.add_development_dependency 'rake',      '~> 10.0'
  spec.add_development_dependency 'rspec',     '~> 3.1.0'
  spec.add_development_dependency 'rspec-its', '~> 1.0'
  spec.add_development_dependency 'webmock',   '~> 1.15'
  spec.add_development_dependency 'vcr',       '~> 2.9'
  spec.add_development_dependency 'coveralls'

  # It should be consistent for Travis and all developers, since we don't check
  # in the Gemfile.lock
  spec.add_development_dependency 'rubocop',       '0.26.1'
  spec.add_development_dependency 'rubocop-rspec', '1.2.0'

  # Release every merge to master as a prerelease
  if ENV['TRAVIS']
    spec.version = "#{spec.version}.pre#{ENV['TRAVIS_BUILD_NUMBER']}"
  end
end
