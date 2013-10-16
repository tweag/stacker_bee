require "multi_json"

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

    def endpoints
      @endpoints ||= self.read_endpoints
    end

    protected

    def read_endpoints
      return unless self.api_path
      json     = File.read(self.api_path)
      response = MultiJson.load(json)
      self.apis_by_endpoint(response)
    end

    def apis_by_endpoint(response)
      response["listapisresponse"]["api"].each_with_object({}) do |api, memo|
        camel = snake_case(api["name"])
        memo[camel] = api
      end
    end
  end
end
