require 'test_helper'
require 'jwt'

module Knock
  class AuthTokenTest < ActiveSupport::TestCase

    def user
      @user ||= users(:one)
    end

    test "decodes HSA with no key" do
      payload = {sub: 1}
      token = JWT.encode payload, Knock.token_secret_signature_key.call, 'HS256'

      assert_equal(Knock::AuthToken.new(token: token).current_user, user)
    end

    test "decodes RSA with public key" do
      payload = {sub: 1}
      rsa_private = OpenSSL::PKey::RSA.generate 2048
      rsa_public = rsa_private.public_key
      token = JWT.encode payload, rsa_private, 'RS256'

      assert_equal(Knock::AuthToken.new(token: token, decrypt_key: rsa_public).current_user, user)

    end
  end
end
