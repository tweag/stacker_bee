require 'stacker_bee/rash'

module StackerBee
  module Middleware
    class RashifyResponse < Base
      def after(env)
        body = env.response.body
        env.response.body = case body
                            when Hash  then Rash.new(body)
                            when Array then body.map { |item| Rash.new(body) }
                            else
                              body
                            end
      end
    end
  end
end
