require "spec_helper"

describe StackerBee::Request do
  let(:endpoint)  { "listStuff" }
  let(:api_key)   { "this_guy" }
  let(:params)    { { list: :all, nothing: nil, deets: [:things, :stuff] } }
  let(:request)   { StackerBee::Request.new endpoint, api_key, params }
  subject { request }
  its(:params) do
    should == {
      list: :all,
      api_key: api_key,
      command: "listStuff",
      nothing: nil,
      deets: [:things, :stuff],
      response: "json"
    }
  end

  describe "#query_params" do
    subject { request.query_params }
    it { should include ["list", :all] }
    it { should include %W(apiKey #{api_key}) }
    it { should include %w(command listStuff) }
    it { should include %w(response json) }
    it { should include %w(deets things,stuff) }
    it "removes params with nil values" do
      subject.map(&:first).should_not include "nothing"
    end
  end
end
