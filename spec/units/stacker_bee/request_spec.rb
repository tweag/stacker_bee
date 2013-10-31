require "spec_helper"

describe StackerBee::Request do
  let(:endpoint)  { "listStuff" }
  let(:api_key)   { "this_guy" }
  let(:params) do
    {
      list:     :all,
      nothing:  nil,
      deets:    [:things, :stuff],
      blank:    ''
    }
  end
  let(:request)   { StackerBee::Request.new endpoint, api_key, params }
  subject { request }
  its(:params) do
    should == {
      list: :all,
      api_key: api_key,
      command: "listStuff",
      nothing: nil,
      blank:   '',
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
    it "removes params with blank values" do
      subject.map(&:first).should_not include "blank"
    end

    context "allowing blank strings" do
      before do
        request.allow_empty_string_params = true
      end
      it { should include ['blank', ''] }
    end
  end
end
