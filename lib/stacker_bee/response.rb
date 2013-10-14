require "forwardable"
require "multi_json"

module StackerBee
  class Response
    extend Forwardable
    def_delegators :body, :[], :[]=, :empty?, :keys, :inspect, :to_s

    attr_reader :body

    def initialize(raw_response)
      @body = MultiJson.load(raw_response.body)
    end
  end
end
