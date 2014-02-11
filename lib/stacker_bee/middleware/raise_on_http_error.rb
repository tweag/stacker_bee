require "stacker_bee/request_error"

module StackerBee
  module Middleware
    class RaiseOnHTTPError < Base
      def after(env)
        fail RequestError.for(env) unless env.raw_response.success?
      end
    end
  end
end
