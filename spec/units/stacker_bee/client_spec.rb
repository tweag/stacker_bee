require "spec_helper"
require "ostruct"

describe StackerBee::Client, ".api" do
  subject { described_class }
  let(:api) { double }
  before do
    StackerBee::API.stub new: api
    described_class.api_path = nil
  end
  its(:api_path) { should_not be_nil }
  its(:api) { should eq api }
end

describe StackerBee::Client, "calling endpoint" do
  let(:client) do
    described_class.new(
      url: "http://example.com",
      middlewares: lambda do |builder|
        builder.before middleware_class,
                       expected_endpoint_name: endpoint_name,
                       expected_params:        params,
                       response_body:          response_body
      end
    )
  end

  let(:middleware_class) do
    Class.new StackerBee::Middleware::Base do
      def call(env)
        fail unless env.request.endpoint_name == expected_endpoint_name
        fail unless env.request.params == expected_params

        env.response.body = response_body
      end

      def endpoint_name_for(*)
        true
      end
    end
  end

  let(:endpoint_name) { :list_virtual_machines }
  let(:params)        { double(:params) }
  let(:response_body) { double(:response_body) }

  describe "responding to methods" do
    subject { client }
    it { should respond_to endpoint_name }
  end

  describe "via a method call" do
    subject { client.list_virtual_machines(params) }
    it { should eq response_body }
  end

  describe "via #request" do
    subject { client.request(endpoint_name, params) }
    it { should eq response_body }
  end
end

describe StackerBee::Client, "configuration" do
  before { described_class.configuration = default_config_hash }

  let(:default_url)         { "default_cloud-stack.com" }
  let(:default_api_key)     { "default-cloud-stack-api-key" }
  let(:default_secret_key)  { "default-cloud-stack-secret-key" }
  let(:default_config_hash) do
    {
      url:                 default_url,
      api_key:             default_api_key,
      secret_key:          default_secret_key,
      faraday_middlewares: proc {},
      middlewares:         proc {}
    }
  end

  let(:instance_url)        { "instance-cloud-stack.com" }
  let(:instance_api_key)    { "instance-cloud-stack-api-key" }
  let(:instance_secret_key) { "instance-cloud-stack-secret-key" }
  let(:instance_config_hash) do
    {
      url:                 instance_url,
      api_key:             instance_api_key,
      secret_key:          instance_secret_key,
      faraday_middlewares: proc {},
      middlewares:         proc {}
    }
  end

  describe ".new" do
    subject { client.configuration }

    context "with default, class configuration" do
      let(:client) { described_class.new }

      its(:url)        { should eq default_url }
      its(:api_key)    { should eq default_api_key }
      its(:secret_key) { should eq default_secret_key }
    end

    context "with instance-specific configuration" do
      let(:client) { described_class.new(instance_config_hash) }

      its(:url)        { should eq instance_url }
      its(:api_key)    { should eq instance_api_key }
      its(:secret_key) { should eq instance_secret_key }
    end

    context "with instance-specific configuration that's not a hash" do
      let(:client) { described_class.new(config) }
      let(:config) { double(to_hash: instance_config_hash) }

      its(:url)        { should eq instance_url }
      its(:api_key)    { should eq instance_api_key }
      its(:secret_key) { should eq instance_secret_key }
    end

    context "with partial instance-specific configuration" do
      let(:client) { described_class.new(partial_config_hash) }
      let(:partial_config_hash) do
        { url: instance_config_hash[:url] }
      end

      its(:url)        { should eq instance_url }
      its(:api_key)    { should eq default_api_key }
      its(:secret_key) { should eq default_secret_key }
    end
  end
end
