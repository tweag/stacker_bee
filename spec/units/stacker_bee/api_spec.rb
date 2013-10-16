require "spec_helper"

describe StackerBee::API do
  let(:api_path) { File.join(File.dirname(__FILE__), '../../fixtures/simple.json') }
  let(:api) { StackerBee::API.new(api_path: api_path) }
  subject { api }
  its(:api_path) { should eq api_path }

  describe "#endpoints" do
    subject { api.endpoints }
    it { should be_a Hash }
    its(:keys) { should include "list_virtual_machines" }
    its(["list_virtual_machines"]) { should be_a Hash }
  end
end
