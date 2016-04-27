require 'test_helper'

class AdminUserProtectedControllerTest < ActionController::TestCase
  def valid_auth
    @admin_user = admin_users(:one)
    @token = Knock::AuthToken.new(payload: { sub: @admin_user.id }).token
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{@token}"
  end

  test "has a current_admin_user after authentication" do
    valid_auth
    get :index
    assert_response :success
    assert @controller.current_admin_user.id == @admin_user.id
  end
end
