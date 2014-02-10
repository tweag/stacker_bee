require "faraday"
require "base64"

module StackerBee
  module HTTPMiddleware
    class Detokenizer < Faraday::Middleware
      def call(env)
        detokenize(env[:url])
        @app.call(env)
      end

      def detokenize(uri)
        uri.query =
          StackerBee::Middleware::DictionaryFlattener.detokenize uri.query
      end
    end
  end
end
