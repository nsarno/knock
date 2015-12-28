require 'jwt'

module Knock
  class AuthToken
    attr_reader :token
    attr_reader :payload

    def initialize payload: {}, token: nil
      if token.present?
        @payload, _ = JWT.decode token, decode_key, true, options
        @token = token
      else
        @payload = payload
        @token = JWT.encode claims.merge(payload),
          secret_key,
          Knock.token_signature_algorithm
      end
    end

    def resource resource_class
      if resource_class.respond_to? :find_for_authentication
        resource_class.find_for_authentication @payload
      else
        resource_class.find @payload['sub']
      end
    end

    def to_json options = {}
      {jwt: @token}.to_json
    end

  private
    def secret_key
      Knock.token_secret_signature_key.call
    end

    def decode_key
      Knock.token_public_key || secret_key
    end

    def options
      verify_claims.merge({
        algorithm: Knock.token_signature_algorithm
      })
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
