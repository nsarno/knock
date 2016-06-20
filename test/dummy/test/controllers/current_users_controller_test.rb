require 'test_helper'

class CurrentUsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @token = Knock::AuthToken.new(payload: { sub: @user.id }).token
  end

  def authenticate token: @token
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{token}"
  end

  test "responds with 404 if user is not logged in" do
    get :show
    assert_response :not_found
  end

  test "responds with 200" do
    authenticate
    get :show
    assert_response :success
  end

  # Run this test twice to validate that it still works
  # when the getter method has already been defined.
  test "responds with 200 #2" do
    authenticate
    get :show
    assert_response :success
  end
end
