require "spec_helper"

describe StackerBee::Client, ".configuration" do
  let(:url)         { "cloud-stack.com" }
  let(:api_key)     { "my-cloud-stack-api-key" }
  let(:secret_key)  { "shh-my-secret-key" }
  let(:configuration) do
    {
      url:        url,
      api_key:    api_key,
      secret_key: secret_key
    }
  end
  before  { StackerBee::Client.configuration = configuration }
  subject { StackerBee::Client }

  its(:configuration) { should eq configuration }
  its(:url)           { should eq url }
  its(:api_key)       { should eq api_key }
  its(:secret_key)    { should eq secret_key }

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
    let(:instance_configuration) do
      {
        url:        instance_url,
        api_key:    instance_api_key,
        secret_key: instance_secret_key
      }
    end
    subject { StackerBee::Client.new }

    context "with default, class configuration" do
      its(:configuration) { should eq configuration }
      its(:url)           { should eq url }
      its(:api_key)       { should eq api_key }
      its(:secret_key)    { should eq secret_key }
    end

    context "with instance-specific configuration" do
      subject { StackerBee::Client.new(instance_configuration) }
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
