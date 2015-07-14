require 'jwt'

module Knock
  cattr_accessor :token_lifetime

  def self.token_lifetime
    @token_lifetime || 1.day
  end

  class AuthToken
    attr_reader :token

    def initialize payload: {}, token: nil
      if token.nil?
        @token = JWT.encode ({ exp: expiration_time }).merge(payload), Rails.application.secrets.secret_key_base, 'HS256'
      else
        @token = token
      end
    end

    def validate!
      JWT.decode @token, Rails.application.secrets.secret_key_base
    end

  private

    def expiration_time
      Knock.token_lifetime.from_now.to_i
    end
  end
end
