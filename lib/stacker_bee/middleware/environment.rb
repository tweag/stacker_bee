require 'ostruct'

module StackerBee
  module Middleware
    class Environment < OpenStruct
      def initialize(request_attributes = {})
        super()

        defaults = { params: {} }
        self.request = Request.new(defaults.merge(request_attributes))

        self.response = Response.new
        self.logger = request_attributes[:logger]
      end

      class Request < OpenStruct
      end

      class Response < OpenStruct
        def success?
          !!success
        end
      end
    end
  end
end
