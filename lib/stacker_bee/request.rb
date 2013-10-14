module StackerBee
  class Request
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

    protected

    def camel_case(string)
      string = string.to_s
      return string if string !~ /_/ && string =~ /[A-Z]+.*/
      string.split('_').map{|e| e.capitalize }.join
    end

    def camel_case_lower(string)
      string.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
    end
  end
end
