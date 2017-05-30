require 'uri'
require 'jwt'
require 'json/jwt'
require 'net/http'

module Knock
  class AuthToken
    attr_reader :token
    attr_reader :payload

    def initialize payload: {}, token: nil, verify_options: {}
      if token.present?
        token_decode_key = decode_key

        if token_decode_key.is_a?(JSON::JWK::Set)
          @payload = JSON::JWT.decode(token.to_s, token_decode_key)
          @options = options.merge(verify_options)

          @options.each do |key, val|
            next unless key.to_s =~ /verify/

            JWT::Verify.send(key, @payload, @options) if val
          end
        else
          @payload, _ = JWT.decode token.to_s, token_decode_key, true, options.merge(verify_options)
        end

        @token = token
      else
        @payload = claims.merge(payload)
        @token = JWT.encode @payload,
          secret_key,
          Knock.token_signature_algorithm
      end
    end

    def entity_for entity_class
      if entity_class.respond_to? :from_token_payload
        entity_class.from_token_payload @payload
      else
        entity_class.find @payload['sub']
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
      if Knock.token_public_key
        if Knock.token_public_key =~ /^#{URI::Parser.new.make_regexp(['http', 'https'])}$/
          # This means there's a JWK or JWKs public key that we need to fetch
          JSON::JWK::Set.new(
            JSON.parse( Net::HTTP.get( URI(Knock.token_public_key) ) )
          )
        else
          Knock.token_public_key
        end
      else
        secret_key
      end
    end

    def options
      verify_claims.merge({
        algorithm: Knock.token_signature_algorithm,
        leeway: 0
      })
    end

    def claims
      _claims = {}
      _claims[:exp] = token_lifetime if verify_lifetime?
      _claims[:aud] = token_audience if verify_audience?
      _claims
    end

    def token_lifetime
      Knock.token_lifetime.from_now.to_i if verify_lifetime?
    end

    def verify_lifetime?
      !Knock.token_lifetime.nil?
    end

    def verify_claims
      {
        aud: token_audience,
        verify_aud: verify_audience?,
        verify_expiration: verify_lifetime?
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
