require 'jwt'

module Knock
  class AuthToken
    attr_reader :token

    def initialize payload: {}, token: nil
      if token.present?
        @payload, _ = JWT.decode token, key, true, verify_claims
        @token = token
      else
        @payload = payload
        @token = JWT.encode(claims.merge(payload), key, 'HS256')
      end
    end

    def current_user
      @current_user ||= Knock.current_user_from_token.call @payload
    end

  private
    def key
      Knock.token_secret_signature_key.call
    end

    def claims
      {
        exp: Knock.token_lifetime.from_now.to_i,
        aud: Knock.token_audience
      }
    end

    def verify_claims
      {
        aud: Knock.token_audience, verify_aud: Knock.token_audience.present?
      }
    end
  end
end
