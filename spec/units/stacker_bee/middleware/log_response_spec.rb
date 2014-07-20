require 'spec_helper'
describe StackerBee::Middleware::LogResponse do
  describe 'after' do
    let(:logger) { FakeLogger.new }

    let(:env) do
      env = StackerBee::Middleware::Environment.new(logger: logger)
      env.raw_response = { body: 'some body' }
      env.request.params = { 'command' => 'some command' }
      env.request.path = 'some/path'
      env
    end

    shared_examples_for 'all logs' do
      it 'logs the details' do
        expect(logger.logs.length).to eq 1
        expect(logger.logs.last[:request_path]).to eq env.request.path
        expect(logger.logs.last[:params]).to eq env.request.params.to_a
        expect(logger.logs.last[:response_body]).to eq env.raw_response[:body]
      end
    end

    context 'error response' do
      before do
        env.response.success = false
        env.response.error = 'invalid request'
        subject.after(env)
      end

      it_should_behave_like 'all logs'
      it 'should have logged the details' do
        expect(logger.logs.last[:short_message]).to eq \
          'some command failed: invalid request'
      end
    end

    context 'success response' do
      before do
        env.response.success = true
        subject.after(env)
      end

      it_should_behave_like 'all logs'
      it 'should have logged the details' do
        expect(logger.logs.length).to eq 1
        expect(logger.logs.last[:short_message]).to eq 'some command'
      end

    end
  end
end
