require "spec_helper"

describe StackerBee::RequestError, ".for" do
  let(:raw_response) do
    double status: status, body: '{"foo": "bar"}', headers: {}
  end
  subject { StackerBee::RequestError.for raw_response }

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
  let(:http_status) { 431 }
  let(:message) do
    "Unable to execute API command deployvirtualmachine " \
    "due to missing parameter zoneid"
  end
  let(:raw_body) do
    <<-EOS
    {
      "deployvirtualmachineresponse": {
        "uuidList":    [],
        "errorcode":   #{http_status},
        "cserrorcode": 9999,
        "errortext":   "#{message}"
      }
    }
    EOS
  end
  let(:raw_response) do
    double body: raw_body, :success? => false, status: 431, headers: {}
  end
  let(:client_error) { StackerBee::ClientError.new raw_response }
  subject { client_error }
  its(:status) { should eq http_status }
  its(:to_s) { should eq message }
end
