require 'spec_helper'

describe StackerBee::Middleware::HTTPStatus do
  subject { env.response }
  before { middleware.after(env) }

  let(:middleware) { described_class.new }
  let(:env) do
    StackerBee::Middleware::Environment.new.tap do |env|
      env.raw_response = double(status: http_status, success?: success?)
      env.response.body = body
    end
  end
  let(:body) { { errorcode: http_status, errortext: message } }
  let(:message) { "Unable to execute API command deployvirtualmachine " }

  context "given an error" do
    let(:http_status) { 431 }
    let(:success?) { false }

    its(:status) { should eq http_status }
    its(:error) { should eq message }
    it { should_not be_success }
  end

  context "given a success" do
    let(:http_status) { 200 }
    let(:success?) { true }

    its(:status) { should eq http_status }
    its(:error) { should be_nil }
    it { should be_success }
  end
end
