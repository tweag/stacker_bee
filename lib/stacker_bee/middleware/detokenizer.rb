require "faraday"
require "base64"

module StackerBee
  module Middleware
    class Detokenizer < Faraday::Middleware
      def call(env)
        detokenize(env[:url])
        @app.call(env)
      end

      def detokenize(uri)
        uri.query = StackerBee::DictionaryFlattener.detokenize uri.query
      end
    end
  end
end
