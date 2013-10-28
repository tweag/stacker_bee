require "stacker_bee/utilities"

module StackerBee
  class Request
    include Utilties

    RESPONSE_TYPE = "json"

    attr_accessor :params

    def initialize(endpoint, api_key, params = {})
      params[:api_key]  = api_key
      params[:command]  = endpoint
      params[:response] = RESPONSE_TYPE
      self.params = params
    end

    def query_params
      params
        .reject { |key, val| val.nil? }
        .sort
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
