require 'test_helper'
require 'jwt'
require 'timecop'

module Knock
  class AuthTokenTest < ActiveSupport::TestCase
    setup do
      key = Knock.token_secret_signature_key.call
      @token = JWT.encode({sub: '1'}, key, 'HS256')
    end

    test "verify algorithm" do
      Knock.token_signature_algorithm = 'RS256'

      assert_raises(JWT::IncorrectAlgorithm) {
        AuthToken.new(token: @token)
      }
    end

    test "decode RSA encoded tokens" do
      rsa_private = OpenSSL::PKey::RSA.generate 2048
      Knock.token_public_key = rsa_private.public_key
      Knock.token_signature_algorithm = 'RS256'

      token = JWT.encode({sub: "1"}, rsa_private, 'RS256')

      assert_nothing_raised { AuthToken.new(token: token) }
    end

    test "encode tokens with RSA" do
      rsa_private = OpenSSL::PKey::RSA.generate 2048
      Knock.token_secret_signature_key = -> { rsa_private }
      Knock.token_signature_algorithm = 'RS256'

      token = AuthToken.new(payload: {sub: '1'}).token

      payload, header = JWT.decode token, rsa_private.public_key, true, { algorithm: 'RS256' }
      assert_equal payload['sub'], '1'
      assert_equal header['alg'], 'RS256'
    end

    test "verify audience when token_audience is present" do
      Knock.token_audience = -> { 'bar' }

      assert_raises(JWT::InvalidAudError) {
        AuthToken.new token: @token
      }
    end

    test "validate expiration claim by default" do
      token = AuthToken.new(payload: {sub: 'foo'}).token
      Timecop.travel(25.hours.from_now) do
        assert_raises(JWT::ExpiredSignature) {
          AuthToken.new(token: token)
        }
      end
    end

    test "does not validate expiration claim with a nil token_lifetime" do
      Knock.token_lifetime = nil

      token = AuthToken.new(payload: {sub: 'foo'}).token
      Timecop.travel(10.years.from_now) do
        assert_not AuthToken.new(token: token).payload.has_key?('exp')
      end
    end

    test "validate aud when verify_options[:verify_aud] is true" do
      verify_options = {
          verify_aud: true
      }
      Knock.token_audience = -> { 'bar' }
      key = Knock.token_secret_signature_key.call
      assert_raises(JWT::InvalidAudError) {
        AuthToken.new token: @token, verify_options: verify_options
      }
    end

    test "does not validate aud when verify_options[:verify_aud] is false" do
      verify_options = {
          verify_aud: false
      }
      Knock.token_audience = -> { 'bar' }
      key = Knock.token_secret_signature_key.call
      assert_not AuthToken.new(token: @token, verify_options: verify_options).payload.has_key?('aud')
    end

    test "validate expiration when verify_options[:verify_expiration] is true" do
      verify_options = {
          verify_expiration: true
      }
      token = AuthToken.new(payload: {sub: 'foo'}).token
      Timecop.travel(25.hours.from_now) do
        assert_raises(JWT::ExpiredSignature) {
          AuthToken.new(token: token, verify_options: verify_options)
        }
      end
    end

    test "does not validate expiration when verify_options[:verify_expiration] is false" do
      verify_options = {
          verify_expiration: false
      }
      token = AuthToken.new(payload: {sub: 'foo'}).token
      Timecop.travel(25.hours.from_now) do
        assert AuthToken.new(token: token, verify_options: verify_options).payload.has_key?('exp')
      end
    end

    test "Knock::AuthToken has all payloads" do
      Knock.token_lifetime = 7.days
      payload = Knock::AuthToken.new(payload: { sub: 'foo' }).payload
      assert payload.has_key?(:sub)
      assert payload.has_key?(:exp)
    end

    test "is serializable" do
      auth_token = AuthToken.new token: @token

      assert_equal("{\"jwt\":\"#{@token}\"}", auth_token.to_json)
    end
  end
end
