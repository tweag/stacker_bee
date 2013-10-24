require "spec_helper"
require "ostruct"

describe StackerBee::Client, ".api" do
  let(:api) { double }
  before do
    StackerBee::API.stub(:new) { api }
    StackerBee::Client.api_path = nil
  end
  subject { StackerBee::Client }
  its(:api_path) { should_not be_nil }
  its(:api) { should eq api }
end

describe StackerBee::Client, "calling endpoint" do
  let(:url)         { "cloud-stack.com" }
  let(:api_key)     { "cloud-stack-api-key" }
  let(:secret_key)  { "cloud-stack-secret-key" }
  let(:config_hash) do
    {
      url:        url,
      api_key:    api_key,
      secret_key: secret_key
    }
  end
  let(:client)      { StackerBee::Client.new config_hash }
  let(:endpoint)    { :list_virtual_machines }
  let(:params)      { { list: :all } }
  let(:connection)  { double }
  let(:request)     { double }
  let(:raw_request) { double }
  let(:list)        { double }
  let(:response)    { list }
  let(:api_path) { File.join(File.dirname(__FILE__), '../../fixtures/simple.json') }
  before do
    StackerBee::Client.api_path = api_path
    StackerBee::Connection.stub(:new) { connection }
    StackerBee::Request.stub(:new).with("listVirtualMachines", api_key, params) { request }
    connection.stub(:get).with(request) { raw_request }
    StackerBee::Response.stub(:new).with(raw_request) { response }
  end

  subject { client }
  it { should respond_to endpoint }
  describe "response to endpoint request" do
    subject { client.list_virtual_machines(params) }
    it { should eq list }
  end
end

describe StackerBee::Client, "#request" do
  subject { client.request(endpoint, params) }
  let(:endpoint)    { "listVirtualMachines" }
  let(:params)      { { list: :all } }

  let(:url)         { "cloud-stack.com" }
  let(:api_key)     { "cloud-stack-api-key" }
  let(:secret_key)  { "cloud-stack-secret-key" }
  let(:config_hash) do
    {
      url:        url,
      api_key:    api_key,
      secret_key: secret_key
    }
  end
  let(:client)      { StackerBee::Client.new config_hash }
  let(:connection)  { double }
  let(:request)     { double }
  let(:raw_request) { double }
  let(:response)    { double }
  before do
    StackerBee::Connection.should_receive(:new) { connection }
    StackerBee::Request.should_receive(:new).with(endpoint, api_key, params) { request }
    connection.should_receive(:get).with(request) { raw_request }
    StackerBee::Response.should_receive(:new).with(raw_request) { response }
  end

  it { should eq response }

  context "called with a differently-cased endpoint" do
    subject { client.request("list_Virtual_mACHINES", params) }
    it { should eq response }
  end
end

describe StackerBee::Client, "configuration" do
  let(:default_url)         { "default_cloud-stack.com" }
  let(:default_api_key)     { "default-cloud-stack-api-key" }
  let(:default_secret_key)  { "default-cloud-stack-secret-key" }
  let(:default_config_hash) do
    {
      url:        default_url,
      api_key:    default_api_key,
      secret_key: default_secret_key
    }
  end
  let!(:default_configuration) { StackerBee::Configuration.new(default_config_hash) }
  let(:instance_url)        { "instance-cloud-stack.com" }
  let(:instance_api_key)    { "instance-cloud-stack-api-key" }
  let(:instance_secret_key) { "instance-cloud-stack-secret-key" }
  let(:instance_config_hash) do
    {
      url:        instance_url,
      api_key:    instance_api_key,
      secret_key: instance_secret_key
    }
  end
  let!(:instance_configuration) { StackerBee::Configuration.new(instance_config_hash) }
  before do
    StackerBee::Configuration.stub(:new) { raise "Unexpected Configuration instantiation" }
    StackerBee::Configuration.stub(:new).with(default_config_hash)  { default_configuration }
    StackerBee::Configuration.stub(:new).with(instance_config_hash) { instance_configuration }
    StackerBee::Client.configuration = default_config_hash
  end

  describe ".new" do
    subject { StackerBee::Client.new }

    context "with default, class configuration" do
      its(:url)           { should eq default_url }
      its(:api_key)       { should eq default_api_key }
      its(:secret_key)    { should eq default_secret_key }
    end

    context "with instance-specific configuration" do
      subject { StackerBee::Client.new(instance_config_hash) }
      its(:configuration) { should eq instance_configuration }
      its(:url)           { should eq instance_url }
      its(:api_key)       { should eq instance_api_key }
      its(:secret_key)    { should eq instance_secret_key }
    end

    describe "#url" do
      let(:other_url) { "other-cloud-stack.com" }
      before { subject.url = other_url }
      its(:url) { should eq other_url }
    end

    describe "#api_key" do
      let(:other_api_key) { "other-cloud-stack-api-key" }
      before { subject.api_key = other_api_key }
      its(:api_key) { should eq other_api_key }
    end

    describe "#secret_key" do
      let(:other_secret_key) { "other-cloud-stack-secret-key" }
      before { subject.secret_key = other_secret_key }
      its(:secret_key) { should eq other_secret_key }
    end
  end
end
