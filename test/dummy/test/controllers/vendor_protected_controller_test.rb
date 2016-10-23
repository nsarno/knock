require 'test_helper'

class VendorProtectedControllerTest < ActionController::TestCase
  def valid_auth
    @vendor = vendors(:one)
    @token = Knock::AuthToken.new(payload: { sub: @vendor.id }).token
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

  test "has a current_vendor after authentication" do
    valid_auth
    get :index
    assert_response :success
    assert @controller.current_vendor.id == @vendor.id
  end

  test "raises method missing error appropriately" do
    assert_raises(NoMethodError) do
      get :show, params: {id: 1}
    end
  end
end
