require 'test_helper'

class ProtectedResourcesControllerTest < ActionController::TestCase
  def authenticate
    @user = users(:one)
    @token = Knock::AuthToken.new(payload: { user_id: @user.id }).token
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{@token}"
  end

  test "responds with unauthorized" do
    get :index
    assert_response :unauthorized
  end

  test "responds with success if authenticated" do
    authenticate
    get :index
    assert_response :success
  end

  test "has a current_user after authentication" do
    authenticate
    get :index
    assert_response :success
    assert @controller.current_user.id == @user.id
  end
end
