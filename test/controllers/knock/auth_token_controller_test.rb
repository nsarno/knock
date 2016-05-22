require 'test_helper'

module Knock
  class AuthTokenControllerTest < ActionController::TestCase
    setup do
      @routes = Engine.routes
    end

    def user
      @user ||= users(:one)
    end

    test "it's using configured custom exception" do
      assert_equal Knock.not_found_exception_class, Knock::MyCustomException
    end

    test "responds with 404 if user does not exist" do
      post :create, auth: { email: 'wrong@example.net', password: '' }
      assert_response :not_found
    end

    test "responds with 404 if password is invalid" do
      post :create, auth: { email: user.email, password: 'wrong' }
      assert_response :not_found
    end

    test "responds with 201" do
      post :create, auth: { email: user.email, password: 'secret' }
      assert_response :created
    end

    test "the JWT contains the custom claims" do
      post :create, auth: { email: user.email, password: 'secret' }

      jwt = JSON.parse(response.body)['jwt']
      assert_equal user.name, Knock::AuthToken.new(token: jwt).payload['name']
    end
  end
end
