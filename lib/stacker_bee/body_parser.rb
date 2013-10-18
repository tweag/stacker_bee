require "multi_json"

module StackerBee
  module BodyParser
    attr_reader :body

    def initialize(raw_response)
      @body = parse(raw_response.body)
    end

    def parse(json)
      parsed = MultiJson.load(json)
      response_key = parsed.keys.first if parsed.keys.size == 1
      raise "Unable to determine response key in #{parsed.keys}" unless response_key
      parsed[response_key]
    end
  end
end
