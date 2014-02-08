module StackerBee
  module Middleware
    class RemoveEmptyStrings < Base
      def before(env)
        Utilities.hash_deeply(env.request.params) do |hash|
          hash.delete_if { |_, val| val == '' }
        end
      end
    end
  end
end
