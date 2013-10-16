require "spec_helper"

describe StackerBee::Response do
  let(:raw_body)          { '{ "json": "here" }' }
  let(:raw_response)  { double body: raw_body }
  let(:response)      { StackerBee::Response.new raw_response }
  subject { response }
  its(:body) { should == 'here' }

  context "raw response for list endpoint" do
    let(:raw_body) { '{ "listvirtualmachinesresponse": {"count": 1, "virtualmachine": ["ohai"] }}' }
    its(:body) { should == ["ohai"] }
  end

  context "raw response for list endpoint with no records" do
    let(:raw_body) { '{ "listvirtualmachinesresponse": {} }' }
    its(:body) { should == {} }
  end

  context "raw response for async endpoint" do
    let(:raw_body) { '{ "deployvirtualmachineresponse": {"id": 123, "jobid": 321} }' }
    its(:body) { should == {"id" => 123, "jobid" => 321} }
  end

  context "raw response for create endpoint" do
    let(:raw_body) { '{ "register_ssh_keypair": {"fingerprint": 456} }' }
    its(:body) { should == {"fingerprint" => 456} }
  end
end
