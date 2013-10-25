require "stacker_bee/body_parser"

module StackerBee
  class RequestError < Exception
    include BodyParser

    def self.for(raw_response)
      klass = case raw_response.status
              when 400..499
                ClientError
              when 500..599
                ServerError
              else
                self
              end
      klass.new(raw_response)
    end

    def status
      body["errorcode"]
    end

    def to_s
      body["errortext"]
    end
  end

  class ServerError < RequestError
  end

  class ClientError < RequestError
  end
end
