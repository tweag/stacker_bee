require "spec_helper"

describe StackerBee::Middleware::ConsoleAccess do
  let(:env) do
    StackerBee::Middleware::Environment.new(endpoint_name: endpoint_name)
  end

  let(:middleware) { described_class.new(app: app) }
  let(:app) { double(:app) }

  context "when it matches the endpoint" do
    let(:endpoint_name) { described_class::ENDPOINT }

    it "adds its path to the env" do
      middleware.before(env)
      env.request.path.should == described_class::PATH
    end

    it "adds cmd to the parameters" do
      env.request.params.should_not include described_class::PARAMS
    end
  end

  context "when it doesn't match the endpoint" do
    let(:endpoint_name) { :other_endpoint }

    before { middleware.before(env) }

    it "doesn't add it's path" do
      env.request.path.should_not == described_class::PATH
    end

    it "doesn't add cmd to the parameters" do
      env.request.params.should_not include described_class::PARAMS
    end
  end

  it "matches html content typtes" do
    middleware.content_types.should =~ "text/html; charset=utf-8"
  end

  describe "#endpoint_name_for" do
    context "given names it reponds to" do
      %w[consoleAccess console_access CONSOLEACCESS].each do |name|
        it "returns consoleAccess for '#{name}'" do
          middleware.endpoint_name_for(name).should == described_class::ENDPOINT
        end
      end
    end

    context "for other names" do
      before { app.stub :endpoint_name_for, &:upcase }

      it "delegates for other names" do
        middleware.endpoint_name_for('other-name').should == 'OTHER-NAME'
      end
    end
  end
end
