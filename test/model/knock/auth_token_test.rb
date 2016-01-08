require 'test_helper'
require 'jwt'

module Knock
  class AuthTokenTest < ActiveSupport::TestCase
    test "verify algorithm" do
      Knock.token_signature_algorithm = 'RS256'
      key = Knock.token_secret_signature_key.call

      token = JWT.encode({sub: '1'}, key, 'HS256')

      assert_raises(JWT::IncorrectAlgorithm) {
        AuthToken.new(token: token)
      }
    end

    test "decode RSA encoded tokens" do
      user = users(:one)
      rsa_private = OpenSSL::PKey::RSA.generate 2048
      Knock.token_public_key = rsa_private.public_key
      Knock.token_signature_algorithm = 'RS256'

      token = JWT.encode({sub: user.id}, rsa_private, 'RS256')

      assert_nothing_raised { AuthToken.new(token: token) }
    end

    test "encode tokens with RSA" do
      rsa_private = OpenSSL::PKey::RSA.generate 2048
      Knock.token_secret_signature_key = -> { rsa_private }
      Knock.token_signature_algorithm = 'RS256'

      token = AuthToken.new(payload: {sub: '1'}).token

      payload, header = JWT.decode token, rsa_private.public_key, true
      assert_equal payload['sub'], '1'
      assert_equal header['alg'], 'RS256'
    end

    test "verify audience when token_audience is present" do
      Knock.token_audience = -> { 'bar' }
      key = Knock.token_secret_signature_key.call

      token = JWT.encode({sub: 'foo'}, key, 'HS256')

      assert_raises(JWT::InvalidAudError) {
        AuthToken.new token: token
      }
    end
  end
end
