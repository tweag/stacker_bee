require 'stacker_bee/rash'

module StackerBee
  module Middleware
    class RashifyResponse < Base
      def after(env)
        body = env.response.body
        env.response.body = case body
                            when Hash  then Rash.new(body)
                            when Array then body.map { |item| Rash.new(item) }
                            else
                              body
                            end
      end

      def content_types
        /javascript/
      end
    end
  end
end
