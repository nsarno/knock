require 'test_helper'

class ProtectedResourcesControllerTest < ActionController::TestCase

  setup do
    @user = users(:one)
    @token = @controller.issue_token({ user_id: @user.id })
  end

  test "responds with unauthorized" do
    get :index
    assert_response :unauthorized
  end

  test "responds with success if authenticated" do
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{@token}"
    get :index
    assert_response :success
  end
end
