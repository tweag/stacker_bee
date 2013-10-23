require "multi_json"
require "stacker_bee/utilities"

module StackerBee
  class API
    include Utilties
    attr_accessor :api_path

    def initialize(attrs = {})
      attrs.each_pair do |key, value|
        setter = "#{key}="
        self.send(setter, value)
      end
    end

    def [](key)
      self.endpoints[uncase(key)]
    end

    def key?(key)
      self.endpoints.key? uncase(key)
    end

    protected

    def endpoints
      @endpoints ||= self.read_endpoints
    end

    def read_endpoints
      return unless self.api_path
      json     = File.read(self.api_path)
      response = MultiJson.load(json)
      self.apis_by_endpoint(response)
    end

    def apis_by_endpoint(response)
      response["listapisresponse"]["api"].each_with_object({}) do |api, memo|
        memo[uncase(api["name"])] = api
      end
    end
  end
end
