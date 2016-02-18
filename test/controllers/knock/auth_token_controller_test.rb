require 'test_helper'

module Knock
  class AuthTokenControllerTest < ActionController::TestCase
    setup do
      @routes = Engine.routes
    end

    def user
      @user ||= users(:one)
    end

    test "responds with 401 if user does not exist" do
      post :create, auth: { email: 'wrong@example.net', password: '' }
      assert_response :unauthorized
    end

    test "responds with 401 if password is invalid" do
      post :create, auth: { email: user.email, password: 'wrong' }
      assert_response :unauthorized
    end

    test "responds with 201" do
      post :create, auth: { email: user.email, password: 'secret' }
      assert_response :created
    end
  end
end
