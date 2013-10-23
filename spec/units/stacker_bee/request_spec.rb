require "spec_helper"

describe StackerBee::Request do
  let(:endpoint)  { "listStuff" }
  let(:api_key)   { "this_guy" }
  let(:params)    { { list: :all } }
  let(:request)   { StackerBee::Request.new endpoint, api_key, params }
  subject { request }
  its(:path)   { should include "api" }
  its(:params) { should == { list: :all, api_key: api_key, command: "listStuff", response: "json" } }

  describe "#query_params" do
    subject { request.query_params }
    it { should include [ "list",     :all        ] }
    it { should include [ "apiKey",   api_key     ] }
    it { should include [ "command",  "listStuff" ] }
    it { should include [ "response", "json"      ] }
  end
end
