# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

require File.expand_path("../../lib/stacker_bee", __FILE__)

require 'yaml'

default_config_file = File.expand_path("../../config.default.yml", __FILE__)
config_file         = File.expand_path("../../config.yml", __FILE__)

CONFIG = YAML.load(File.read(default_config_file))
CONFIG.merge!(YAML.load(File.read(config_file))) if File.exist?(config_file)

require 'webmock/rspec'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.before :each do
    StackerBee::Client.reset!
  end
end

require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/cassettes'

  c.filter_sensitive_data('<CLOUD_STACK_URL>') do
    CONFIG["url"]
  end

  c.filter_sensitive_data('<CLOUD_STACK_HOST>') do
    uri = URI.parse(CONFIG["url"])
    "#{uri.scheme}://#{uri.host}:#{uri.port}"
  end

  c.filter_sensitive_data('<CLOUD_STACK_API_KEY>') do
    CONFIG["api_key"]
  end

  c.filter_sensitive_data('<CLOUD_STACK_SECRET_KEY>') do
    CONFIG["secret_key"]
  end

  c.default_cassette_options = {
    record: :new_episodes,
    match_requests_on: [
      :method,
      VCR.request_matchers.uri_without_param(:signature)
    ]
  }

  c.configure_rspec_metadata!
end
