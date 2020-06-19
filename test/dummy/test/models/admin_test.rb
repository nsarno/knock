require 'test_helper'
require 'timecop'

class AdminTest < ActiveSupport::TestCase
  def setup
    @admin = admins(:one)
  end

  test "returns payload with :sub" do
    assert_equal @admin.to_token_payload[:sub], @admin.id
  end

  test "returns encoded JWT token" do
    Timecop.travel(Time.current) do
      token = Knock::AuthToken.new(payload: { sub: @admin.id }).token

      assert_equal @admin.to_token, token
    end
  end

  test "returns a Admin instance using a decoded payload" do
    payload = Knock::AuthToken.new(payload: { "sub" => @admin.id }).payload

    assert_equal Admin.from_token_payload(payload), @admin
  end


  test "returns a Admin instance using a token" do
    token = @admin.to_token

    assert_equal Admin.from_token(token), @admin
  end
end
