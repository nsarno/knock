require 'test_helper'

class ProtectedResourcesControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
    @token = Knock::AuthToken.new(payload: { sub: @user.id }).token
  end

  def authenticate token: @token
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{token}"
  end

  test "responds with unauthorized" do
    get :index
    assert_response :unauthorized
  end

  test "responds with success with valid token in header" do
    authenticate
    get :index
    assert_response :success
  end

  test "responds with unauthorized with invalid token in header" do
    authenticate token: "invalid"
    get :index
    assert_response :unauthorized
  end

  test "responds with success with token in url" do
    get :index, token: @token
    assert_response :success
  end

  test "responds with unauthorized with invalid token in url" do
    get :index, token: "invalid"
    assert_response :unauthorized
  end

  test "has a current_user after authentication" do
    authenticate
    get :index
    assert_response :success
    assert @controller.current_user.id == @user.id
  end
end
