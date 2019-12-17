require "jwt"

module Knock
  class AuthToken
    attr_reader :token
    attr_reader :payload
    attr_reader :entity_class

    def initialize(payload: {}, token: nil, verify_options: {}, entity_class: nil)
      if token.present?
        @payload, _ = JWT.decode token.to_s, decode_key, true, options.merge(verify_options)
        @token = token
      else
        @payload = claims.merge(payload)
        @token = JWT.encode @payload,
                            secret_key,
                            Knock.token_signature_algorithm
      end
      @entity_class = entity_class
    end

    def entity_for(entity_klass)
      if entity_klass.respond_to? :from_token_payload
        entity_klass.from_token_payload @payload
      else
        entity_klass.find @payload["sub"]
      end
    end

    def to_json(options = {})
      { jwt: @token }.to_json
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
        algorithm: Knock.token_signature_algorithm,
      })
    end

    def claims
      _claims = {}
      _claims[:exp] = token_lifetime if verify_lifetime?
      _claims[:aud] = token_audience if verify_audience?
      _claims
    end

    def token_lifetime
      return unless verify_lifetime?

      if Knock.token_lifetime.is_a?(Hash)
        Knock.token_lifetime[entity_class.to_s.parameterize.underscore.to_sym].from_now.to_i
      else
        Knock.token_lifetime.from_now.to_i
      end
    end

    def verify_lifetime?
      !Knock.token_lifetime.nil?
    end

    def verify_claims
      {
        aud: token_audience,
        verify_aud: verify_audience?,
        verify_expiration: verify_lifetime?,
      }
    end

    def token_audience
      verify_audience? && Knock.token_audience.call
    end

    def verify_audience?
      Knock.token_audience.present?
    end
  end
end
