require 'spec_helper'
require 'logger'

describe 'A response to a request sent to the CloudStack API', :vcr do
  subject { client.list_accounts }

  let(:url) { CONFIG['url'] }
  let(:config_hash) do
    {
      url:         url,
      api_key:     CONFIG['api_key'],
      secret_key:  CONFIG['secret_key'],
      middlewares: middlewares
    }
  end
  let(:middlewares) { proc {} }

  let(:client) do
    StackerBee::Client.new(config_hash)
  end

  it { is_expected.not_to be_empty }

  context 'first item' do
    subject { client.list_accounts.first }
    it { is_expected.to include 'id' }
    its(['accounttype'])  { should be_a Numeric }
    its(['account_type']) { should be_a Numeric }
  end

  context 'failing to connect' do
    let(:url) { 'http://127.0.0.1:666/client/api' }
    it 'raises a helpful exception' do
      klass = StackerBee::ConnectionError
      expect { subject }.to raise_error klass, /#{url}/
    end
  end

  context 'trailing slash in URL', :regression do
    let(:url) { CONFIG['url'].gsub(/\/$/, '') + '/' }
    it 'makes request with trailing slash' do
      stub = stub_request(:get, /#{url}/).to_return(body: '{"foo": {}}')
      subject
      expect(stub).to have_been_requested
    end
  end

  context 'space character in a request parameter', :regression do
    subject { client.list_accounts(params) }
    let(:params) { { name: 'stacker bee' } }

    it 'properly signs the request' do
      expect { subject }.not_to raise_error
    end
  end

  context 'a nil request parameter' do
    subject { client.list_accounts(params) }
    let(:params) { { name: nil } }

    it 'properly executes the request' do
      expect { subject }.not_to raise_error
    end
  end

  context 'a request parameter with and empty string', :regression do
    subject { client.list_accounts(params) }
    let(:params) { { name: '' } }

    it 'properly executes the request' do
      expect { subject }.not_to raise_error
    end
  end

  context 'a request that triggers an error' do
    subject { client.list_accounts(domain_id: 666) }

    let(:message) { "Domain id=666 doesn't exist" }
    it 'properly signs the request' do
      expect { subject }.to raise_error StackerBee::ClientError, message
    end
  end

  context 'a request parameter with an Array', :regression do
    subject { client.list_hosts(params).first.keys }
    let(:params) { { page: 1, pagesize: 1, details: [:events, :stats] } }
    it { is_expected.to include 'cpuused' }
    it { is_expected.to include 'events' }
    it { is_expected.not_to include 'cpuallocated' }
  end

  context 'a request parameter with a map' do
    let(:zone_id) { client.list_zones.first['id'] }
    let(:service_offering_id) { service_offerings.first['id'] }

    let(:service_offerings) do
      client.list_network_offerings(
        supported_services: 'sourcenat',
        type: 'isolated'
      )
    end

    let(:network) do
      client.create_network(zone_id: zone_id,
                            network_offering_id: service_offering_id,
                            name: 'John', displaytext: 'John')
    end

    let(:tag) do
      client.create_tags(resource_type: 'Network',
                         resource_ids: network['id'],
                         tags: { 'speed [lab]' => 'real fast!' })
    end

    it 'can create an object' do
      expect(tag).not_to be_nil
    end
  end

  describe 'middleware' do
    let(:middlewares) do
      lambda do |builder|
        builder.use middleware_class
      end
    end

    context 'a middleware that matches the content type' do
      let(:middleware_class) do
        Class.new(StackerBee::Middleware::Base) do
          def content_types
            /javascript/
          end

          def after(_env)
            fail 'Middleware Used'
          end
        end
      end

      it 'uses the middleware' do
        expect { client.list_accounts }.to raise_error 'Middleware Used'
      end
    end

    context "a middleware that doesn't match the content type" do
      let(:middleware_class) do
        Class.new(StackerBee::Middleware::Base) do
          def content_types
            /html/
          end

          def after(_env)
            fail 'Middleware Used'
          end
        end
      end

      it 'uses the middleware' do
        expect { client.list_accounts }.not_to raise_error
      end
    end
  end
end
