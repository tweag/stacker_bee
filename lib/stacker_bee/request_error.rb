module StackerBee
  class RequestError < StandardError
    attr_accessor :env, :status

    def initialize(env)
      self.env = env
      self.status = env.response.status
      super env.response.error
    end

    def self.for(env)
      klass = case env.response.status
              when 401      then AuthenticationError
              when 400..499 then ClientError
              when 500..599 then ServerError
              else
                self
              end
      klass.new(env)
    end
  end

  class ServerError < RequestError
  end

  class ClientError < RequestError
  end

  class AuthenticationError < ClientError
  end
end
