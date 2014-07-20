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
  let(:body) { { errorcode: http_status } }

  context 'given an error' do
    let(:http_status) { 431 }
    let(:success?) { false }

    its(:status) { should eq http_status }
    it { is_expected.not_to be_success }
  end

  context 'given a success' do
    let(:http_status) { 200 }
    let(:success?) { true }

    its(:status) { should eq http_status }
    it { is_expected.to be_success }
  end
end
