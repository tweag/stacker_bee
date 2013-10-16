module StackerBee
  class Request
    include Utilties

    RESPONSE_TYPE = "json"

    attr_accessor :params

    def initialize(endpoint, api_key, params = {})
      params[:api_key]  = api_key
      params[:command]  = camel_case_lower(endpoint)
      params[:response] = RESPONSE_TYPE
      self.params = params
    end

    def path
      "/client/api/"
    end

    def query_params
      self.params.to_a.sort!.map!{|(key, val)| [camel_case_lower(key), val] }
    end
  end
end
