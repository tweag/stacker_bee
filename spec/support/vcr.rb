require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/cassettes'

  c.filter_sensitive_data('<CLOUD_STACK_URL>') do
    CONFIG['url']
  end

  c.filter_sensitive_data('<CLOUD_STACK_HOST>') do
    uri = URI.parse(CONFIG['url'])
    "#{uri.scheme}://#{uri.host}:#{uri.port}"
  end

  c.filter_sensitive_data('<CLOUD_STACK_API_KEY>') do
    CONFIG['api_key']
  end

  c.filter_sensitive_data('<CLOUD_STACK_SECRET_KEY>') do
    CONFIG['secret_key']
  end

  c.default_cassette_options = {
    record:            :new_episodes,
    match_requests_on: [
      :method,
      VCR.request_matchers.uri_without_param(:signature)
    ]
  }

  c.configure_rspec_metadata!
end
