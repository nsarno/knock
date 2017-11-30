require 'test_helper'
require 'jwt'
require 'timecop'

module Knock
  class AuthServiceTest < ActiveSupport::TestCase
    setup do
      key = Knock.token_secret_signature_key.call
      @token = JWT.encode({ sub: '1' }, key, 'HS256')
    end

    test 'throw exception when token empty' do
      assert_raises(JWT::DecodeError) {
        AuthService.new(token: nil)
      }
    end

    test 'throw exception when token incorrect' do
      assert_raises(JWT::DecodeError) {
        AuthService.new(token: { sub: 'incorrect token', exp: 2.day })
      }
    end

    test 'verify algorithm' do
      Knock.token_signature_algorithm = 'RS256'

      assert_raises(JWT::IncorrectAlgorithm) {
        AuthService.new(token: @token)
      }
    end

    test 'decode RSA encoded tokens' do
      rsa_private = OpenSSL::PKey::RSA.generate 2048
      Knock.token_public_key = rsa_private.public_key
      Knock.token_signature_algorithm = 'RS256'

      token = JWT.encode({ sub: '1' }, rsa_private, 'RS256')

      assert_nothing_raised { AuthService.new(token: token) }
    end

    test 'verify audience when token_audience is present' do
      Knock.token_audience = -> { 'bar' }

      assert_raises(JWT::InvalidAudError) {
        AuthService.new token: @token
      }
    end

    test 'validate expiration claim by default' do
      token =
        JWT.encode(
          {sub: '1', exp: Knock.token_lifetime},
          Knock.token_secret_signature_key.call,
          Knock.token_signature_algorithm
        )
      Timecop.travel(25.hours.from_now) do
        assert_raises(JWT::ExpiredSignature) {
          AuthService.new(token: token)
        }
      end
    end

    test 'does not validate expiration claim with a nil token_lifetime' do
      Knock.token_lifetime = nil
      token = JWT.encode({ sub: '1' }, Knock.token_secret_signature_key.call, Knock.token_signature_algorithm)
      Timecop.travel(10.years.from_now) do
        assert_not AuthService.new(token: token).payload.key?('exp')
      end
    end

    test 'validate aud when verify_options[:verify_aud] is true' do
      verify_options = {
          verify_aud: true
      }
      Knock.token_audience = -> { 'bar' }
      key = Knock.token_secret_signature_key.call
      assert_raises(JWT::InvalidAudError) {
        AuthService.new token: @token, verify_options: verify_options
      }
    end

    test 'does not validate aud when verify_options[:verify_aud] is false' do
      verify_options = {
        verify_aud: false
      }
      Knock.token_audience = -> { 'bar' }
      key = Knock.token_secret_signature_key.call
      assert_not AuthService.new(token: @token, verify_options: verify_options).payload.key?('aud')
    end

    test 'validate expiration when verify_options[:verify_expiration] is true' do
      verify_options = {
        verify_expiration: true
      }
      token =
        JWT.encode(
          { sub: '1', exp: Knock.token_lifetime },
          Knock.token_secret_signature_key.call,
          Knock.token_signature_algorithm
        )
      Timecop.travel(26.hours.from_now) do
        assert_raises(JWT::ExpiredSignature) {
          AuthService.new(token: token, verify_options: verify_options)
        }
      end
    end

    test 'does not validate expiration when verify_options[:verify_expiration] is false' do
      verify_options = {
        verify_expiration: false
      }
      token =
        JWT.encode(
          { sub: '1', exp: Knock.token_lifetime },
          Knock.token_secret_signature_key.call,
          Knock.token_signature_algorithm
        )
      Timecop.travel(25.hours.from_now) do
        assert AuthService.new(token: token, verify_options: verify_options).payload.key?('exp')
      end
    end
  end
end
