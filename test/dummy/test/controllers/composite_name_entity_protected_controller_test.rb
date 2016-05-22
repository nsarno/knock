require 'test_helper'

class CompositeNameEntityProtectedControllerTest < ActionController::TestCase
  def valid_auth
    @composite_name_entity = composite_name_entities(:one)
    @token = Knock::AuthToken.new(payload: { sub: @composite_name_entity.id }).token
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

  test "responds with unauthorized" do
    get :index
    assert_response :unauthorized
  end

  test "responds with unauthorized to invalid token" do
    invalid_token_auth
    get :index
    assert_response :unauthorized
  end

  test "responds with unauthorized to invalid entity" do
    invalid_entity_auth
    get :index
    assert_response :unauthorized
  end

  test "responds with success if authenticated" do
    valid_auth
    get :index
    assert_response :success
  end

  test "has a current_composite_name_entity after authentication" do
    valid_auth
    get :index
    assert_response :success
    assert @controller.current_composite_name_entity.id == @composite_name_entity.id
  end
end
