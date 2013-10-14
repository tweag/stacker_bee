require "spec_helper"

describe StackerBee::Response do
  let(:body)          { '{ "json": "here" }' }
  let(:raw_response)  { double body: body }
  let(:response)      { StackerBee::Response.new raw_response }
  subject { response }
  its(:body) { should == { 'json' => 'here' } }
  its(['json']) { should eq "here" }
end
