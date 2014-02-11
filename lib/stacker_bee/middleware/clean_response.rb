module StackerBee
  module Middleware
    class CleanResponse < Base
      def after(env)
        body = env.response.body

        clean_body =
          if !body.respond_to? :keys
            body
          elsif body.size == 2 && body.key?("count")
            body.reject { |key, val| key == "count" }.values.first
          elsif body.size == 1 && body.values.first.respond_to?(:keys)
            body.values.first
          else
            body
          end

        env.response.body = clean_body
      end
    end
  end
end

