require 'test_helper'
# require 'timecop'

module Knock
  class TestNamespacedControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = V1::User.first
      @token = Knock::AuthToken.new(payload: { sub: @user.id }).token
    end

    test "allow namespaced models" do
      get v1_test_namespaced_index_url, headers: {'Authorization': "Bearer #{@token}"}
      assert_response :ok
      assert_equal @user, @controller.current_v1_user
    end

    test 'responds with unauthorized' do
      get v1_test_namespaced_index_url
      assert_response :unauthorized
    end

    test 'responds with unauthorized with invalid token in header' do
      get v1_test_namespaced_index_url, headers: {'Authorization': 'Bearer invalid'}
      assert_response :unauthorized
    end
  end
end
