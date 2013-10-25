require "multi_json"
require "stacker_bee/utilities"

module StackerBee
  class API
    include Utilties
    attr_accessor :api_path

    def initialize(attrs = {})
      attrs.each_pair do |key, value|
        setter = "#{key}="
        send(setter, value)
      end
    end

    def [](key)
      endpoints[uncase(key)]
    end

    def key?(key)
      endpoints.key? uncase(key)
    end

    protected

    def endpoints
      @endpoints ||= read_endpoints
    end

    def read_endpoints
      return unless api_path
      json     = File.read(api_path)
      response = MultiJson.load(json)
      apis_by_endpoint(response)
    end

    def apis_by_endpoint(response)
      response["listapisresponse"]["api"].each_with_object({}) do |api, memo|
        memo[uncase(api["name"])] = api
      end
    end
  end
end
