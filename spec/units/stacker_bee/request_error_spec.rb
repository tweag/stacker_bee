require "spec_helper"

describe "An error occuring" do
  let(:env)      { double response: response }
  let(:response) { double status: status, error: error_text }
  let(:error_text) { "There was an error!" }
  let(:status)   { 431 }

  describe StackerBee::RequestError, ".for" do
    subject { StackerBee::RequestError.for env }

    context "HTTP status in the 400s" do
      let(:status) { 431 }
      it { should be_a StackerBee::ClientError }
    end
    context "HTTP status in the 500s" do
      let(:status) { 500 }
      it { should be_a StackerBee::ServerError }
    end
    context "HTTP status > 599" do
      let(:status) { 999 }
      it { should be_a StackerBee::RequestError }
    end
  end

  describe StackerBee::RequestError do
    subject {  StackerBee::ClientError.new(env) }

    its(:status) { should eq status }
    its(:to_s) { should eq error_text }
  end
end
