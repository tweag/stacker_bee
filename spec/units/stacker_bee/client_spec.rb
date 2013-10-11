require "spec_helper"
require "ostruct"

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
  let(:default_configuration) { OpenStruct.new(default_config_hash) }
  before  do
    StackerBee::Configuration.stub(:new).with(default_config_hash) { default_configuration }
    StackerBee::Client.configuration = default_config_hash
  end
  subject { StackerBee::Client }
  its(:configuration) { should be default_configuration }
  its(:url)           { should eq default_url }
  its(:api_key)       { should eq default_api_key }
  its(:secret_key)    { should eq default_secret_key }

  describe ".url" do
    let(:other_url) { "other-cloud-stack.com" }
    before { subject.url = other_url }
    its(:url) { should eq other_url }
  end

  describe ".api_key" do
    let(:other_api_key) { "other-cloud-stack-api-key" }
    before { subject.api_key = other_api_key }
    its(:api_key) { should eq other_api_key }
  end

  describe ".secret_key" do
    let(:other_secret_key) { "other-cloud-stack-secret-key" }
    before { subject.secret_key = other_secret_key }
    its(:secret_key) { should eq other_secret_key }
  end

  describe ".new" do
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
    let(:instance_configuration) { OpenStruct.new(instance_config_hash) }
    before  do
      StackerBee::Configuration.stub(:new) { default_configuration }
      StackerBee::Configuration.stub(:new).with(instance_config_hash) { instance_configuration }
    end
    subject { StackerBee::Client.new }

    context "with default, class configuration" do
      its(:configuration) { should eq default_configuration }
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
