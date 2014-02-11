require "spec_helper"

describe StackerBee::Response do
  let(:raw_body)          { '{ "json": "here" }' }
  let(:raw_response) do
    double(body: raw_body, success?: true, headers: headers)
  end
  let(:response)     { StackerBee::Response.new raw_response }
  let(:headers)      { { 'content-type' => content_type } }
  let(:content_type) { "application/json; charset=UTF-8" }
  subject { response }
  its(:body) { should == 'here' }

  context "raw response for list endpoint" do
    let(:raw_body) do
      '{ "listvirtualmachinesresponse":
        { "count": 1, "virtualmachine": [{"ohai": "there"}] }
      }'
    end
    its(:body) { should == [{ "ohai" => "there" }] }

    context "first item" do
      subject { response.first }
      it { should == { "ohai" => "there" } }
      its(["o_hai"]) { should == "there" }
    end
  end

  context "raw response for list endpoint with no records" do
    let(:raw_body) { '{ "listvirtualmachinesresponse": {} }' }
    its(:body) { should == {} }
  end

  context "raw response for async endpoint" do
    let(:raw_body) do
      '{ "deployvirtualmachineresponse": { "id": 123, "jobid": 321 } }'
    end
    its(:body) { should == { "id" => 123, "jobid" => 321 } }
  end

  context "raw response for create endpoint" do
    let(:raw_body) { '{ "register_ssh_keypair": { "fingerprint": 456 } }' }
    its(:body) { should == { "fingerprint" => 456 } }
  end

  context "for failed request" do
    let(:raw_response) do
      double(
        :body     => '{ "foo": "bar" }',
        :success? => false,
        :status   => 431,
        :headers  => {}
      )
    end
    it { expect { subject }.to raise_exception StackerBee::ClientError }
  end

  context "for response with single key that's an object" do
    let(:raw_body) { '{ "getuserresponse": { "user": { "id": 1 } } }' }
    its(:body) { should == { "id" => 1 } }
  end

  context "for request with invalid credentials" do
    let(:raw_response) do
      double(
        body: %[
          { "createprojectresponse" :
            {"uuidList":[],"errorcode":401,"errortext":"#{message}"} } ],
        success?: false,
        status: 401,
        headers: {}
      )
    end
    let(:client_error) { StackerBee::AuthenticationError.new raw_response }
    let(:message) do
      "unable to verify user credentials and/or request signature"
    end
    it "raises an AuthenticationError" do
      expect { subject }.to raise_exception(
        StackerBee::AuthenticationError, message
      )
    end
  end

  context "with an html response" do
    let(:raw_body) { "<html><body>hi</body><html>" }
    let(:content_type) { "text/html" }

    it "returns the raw html without parsing" do
      expect(response.body).to eq(raw_body)
    end
  end
end
