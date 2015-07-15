require 'jwt'

module Knock
  class AuthToken
    attr_reader :token

    def initialize payload: {}, token: nil
      @token = token || JWT.encode(claims.merge(payload), key, 'HS256')
    end

    def validate!
      JWT.decode @token, key, true, verify_claims
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
        aud: Knock.token_audience, verify_claims: Knock.token_audience.present?
      }
    end
  end
end
