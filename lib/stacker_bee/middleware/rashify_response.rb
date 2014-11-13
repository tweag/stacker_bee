require 'stacker_bee/rash'

module StackerBee
  module Middleware
    class RashifyResponse < Base
      def after(env)
        body = env.response.body
        env.response.body = case body
                            when Hash  then rashify(body)
                            when Array then body.map(&method(:rashify))
                            else
                              body
                            end
      end

      def rashify(item)
        Rash.new(item, preferred_keys)
      end

      def content_types
        /javascript/
      end
    end
  end
end
