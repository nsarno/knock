require 'test_helper'
require 'jwt'

module Knock
  class AuthTokenTest < ActiveSupport::TestCase
    setup do
      Knock.token_secret_signature_key = -> { 'secret' }
    end

    test "verifies audience when token_audience is present" do
      Knock.token_audience = 'foobar'
      token = JWT.encode({ sub: 'foo' }, 'secret', 'HS256')

      assert_raises(JWT::InvalidAudError) {
        AuthToken.new token: token
      }
    end
  end
end
