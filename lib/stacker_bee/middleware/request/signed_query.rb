require "faraday"
require "base64"

module StackerBee
  module Middleware
    module Request
      class SignedQuery < Faraday::Middleware
        def initialize(app, key)
          @key = key
          super(app)
        end

        def call(env)
          sign_uri(env[:url])
          @app.call(env)
        end

        def sign_uri(uri)
          downcased = uri.query.downcase
          signed    = OpenSSL::HMAC.digest 'sha1', @key, downcased
          encoded   = Base64.encode64(signed).chomp
          escaped   = CGI.escape(encoded)
          uri.query << "&signature=#{escaped}"
        end
      end
    end
  end
end
