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
      post :create, params: { auth:
        { email: 'wrong@example.net', password: '' }
      }
      assert_response :not_found
    end

    test "responds with 404 if password is invalid" do
      post :create, params: { auth: { email: user.email, password: 'wrong' } }
      assert_response :not_found
    end

    test "responds with 201" do
      post :create, params: { auth: { email: user.email, password: 'secret' } }
      assert_response :created
    end

    test "response contains token" do
      post :create, params: { auth: { email: user.email, password: 'secret' } }

      content = JSON.parse(response.body)
      assert_equal true, content.has_key?("jwt")
    end
  end
end
