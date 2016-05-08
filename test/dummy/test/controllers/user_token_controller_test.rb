require 'test_helper'

class UserTokenControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
  end

  test "responds with 404 if user does not exist" do
    post :create, auth: { email: 'wrong@example.net', password: '' }
    assert_response :not_found
  end

  test "responds with 404 if password is invalid" do
    post :create, auth: { email: @user.email, password: 'wrong' }
    assert_response :not_found
  end

  test "responds with 201" do
    post :create, auth: { email: @user.email, password: 'secret' }
    assert_response :created
    assert JSON.parse(response.body).has_key?('jwt')
  end

  test "the JWT contains the custom claims" do
    post :create, auth: { email: @user.email, password: 'secret' }

    jwt = JSON.parse(response.body)['jwt']
    assert Knock::AuthToken.new(token: jwt).payload.has_key?('name')
  end
end
