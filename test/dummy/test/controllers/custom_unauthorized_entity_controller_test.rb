require 'test_helper'

class CustomUnauthorizedEntityControllerTest < ActionController::TestCase
  def valid_auth
    @user = users(:one)
    @token = Knock::AuthToken.new(payload: { sub: @user.id }).token
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{@token}"
  end

  def invalid_token_auth
    @token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{@token}"
  end

  def invalid_entity_auth
    @token = Knock::AuthToken.new(payload: { sub: 0 }).token
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{@token}"
  end

  test "responds with not found" do
    get :index
    assert_response :not_found
  end

  test "responds with not found to invalid token" do
    invalid_token_auth
    get :index
    assert_response :not_found
  end

  test "responds with not found to invalid entity" do
    invalid_entity_auth
    get :index
    assert_response :not_found
  end

  test "responds with success if authenticated" do
    valid_auth
    get :index
    assert_response :success
  end
end
