require 'test_helper'

class GuestProtectedControllerTest < ActionController::TestCase
  def setup
    @token = Knock::AuthToken.new(payload: { sub: "1" }).token
  end

  def authenticate token: @token
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{token}"
  end

  test "responds with unauthorized when no token is provided" do
    get :index
    assert_response :unauthorized
  end

  test "responds with success with a valid token in the header" do
    authenticate
    get :index
    assert_response :success
  end
end
