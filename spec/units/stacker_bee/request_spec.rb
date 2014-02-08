require "spec_helper"

describe StackerBee::Request do
  subject { request }

  let(:request) { StackerBee::Request.new endpoint, api_key, params }

  let(:endpoint)  { "listStuff" }
  let(:api_key)   { "this_guy" }
  let(:params) do
    {
      list:     :all,
      nothing:  nil,
      deets:    [:things, :stuff],
      settings: { cookiename: "Fred", something: "cool" }
    }
  end

  describe "#query_params" do
    let(:new_params) { params.merge("settings[1].name" => "cool") }
    let(:flattener)  { double(new: double(params: new_params)) }

    before do
      stub_const "StackerBee::DictionaryFlattener", flattener
    end

    subject { request.query_params }

    it { should include ["settings[1].name", "cool"] }
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
