require "stacker_bee/utilities"

module StackerBee
  class Request
    include Utilities

    RESPONSE_TYPE = "json"

    attr_accessor :endpoint, :api_key

    def initialize(endpoint, api_key, params = {})
      @params = params
      self.endpoint = endpoint
      self.api_key  = api_key
    end

    def query_params
      flat_params = DictionaryFlattener.new(@params).params

      flat_params[:api_key]  = api_key
      flat_params[:command]  = endpoint
      flat_params[:response] = RESPONSE_TYPE

      flat_params
        .reject { |key, val| val.nil? }
        .sort_by { |key, val| key.to_s }
        .map { |(key, val)| [cloud_stack_key(key), cloud_stack_value(val)] }
    end

    private

    def cloud_stack_key(key)
      camel_case(key, true)
    end

    def cloud_stack_value(value)
      value.respond_to?(:join) ? value.join(',') : value
    end
  end
end
