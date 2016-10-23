require 'test_helper'

class VendorTokenControllerTest < ActionController::TestCase
  def setup
    @vendor = vendors(:one)
  end

  test "responds with 404 if user does not exist" do
    post :create, params: {auth: { email: 'wrong@example.net', password: '' }}
    assert_response :not_found
  end

  test "responds with 404 if password is invalid" do
    post :create, params: {auth: { email: @vendor.email, password: 'wrong' }}
    assert_response :not_found
  end

  test "responds with 201" do
    post :create, params: {auth: { email: @vendor.email, password: 'secret' }}
    assert_response :created
  end
end
