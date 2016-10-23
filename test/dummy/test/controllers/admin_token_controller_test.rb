require 'test_helper'

class AdminTokenControllerTest < ActionController::TestCase
  def setup
    @admin = admins(:one)
  end

  test "responds with 404 if user does not exist" do
    post :create, params: {auth: { email: 'wrong@example.net', password: '' }}
    assert_response :not_found
  end

  test "responds with 404 if password is invalid" do
    post :create, params: {auth: { email: @admin.email, password: 'wrong' }}
    assert_response :not_found
  end

  test "responds with 201" do
    post :create, params: {auth: { email: @admin.email, password: 'secret' }}
    assert_response :created
  end
end
