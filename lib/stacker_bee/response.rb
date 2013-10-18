require "forwardable"
require "stacker_bee/body_parser"
require "stacker_bee/request_error"

module StackerBee
  class Response
    include BodyParser
    extend Forwardable
    def_delegators :body, :[], :[]=, :empty?, :keys, :inspect, :to_s, :first

    def initialize(raw_response)
      raise RequestError.for(raw_response) unless raw_response.success?
      super(raw_response)
    end

    protected

    def parse(json)
      parsed = super(json)
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
