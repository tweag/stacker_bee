module StackerBee
  module Middleware
    class RemoveEmptyStrings < Base
      def call(env)
        Utilities.hash_deeply(env.request.params) do |hash|
          hash.delete_if { |_, val| val == '' }
        end

        app.call(env)
      end
    end
  end
end
