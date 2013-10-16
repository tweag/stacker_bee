require "forwardable"
require "multi_json"

module StackerBee
  class Response
    extend Forwardable
    def_delegators :body, :[], :[]=, :empty?, :keys, :inspect, :to_s, :first

    attr_reader :body

    def initialize(raw_response)
      @body = parse(raw_response.body)
    end

    protected

    def parse(json)
      parsed = MultiJson.load(json)
      response_key = parsed.keys.first if parsed.keys.size == 1
      raise "Unable to determine response key in #{parsed.keys}" unless response_key
      parsed = parsed[response_key]
      return parsed unless parsed.respond_to? :keys
      keys = parsed.keys
      if keys.include?("count") && keys.size == 2
        keys.delete("count")
        parsed[keys.first]
      else
        parsed
      end
    end
  end
end
