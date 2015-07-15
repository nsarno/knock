require 'jwt'

module Knock
  class AuthToken
    attr_reader :token

    def initialize payload: {}, token: nil
      @token = token || JWT.encode ({ exp: expiration_time }).merge(payload), Knock.token_secret_signature_key, 'HS256'
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
