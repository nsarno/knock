require 'test_helper'
# require 'timecop'

module Knock
  class TestNamespacedControllerTest < ActionDispatch::IntegrationTest

    setup do
      @user = V1::User.first
    end

    test "allow namespaced models" do
      token = Knock::AuthToken.new(payload: { sub: @user.id }).token
      get v1_test_namespaced_index_url, headers: {'Authorization': "Bearer #{token}"}
      assert_response :ok
      assert_equal @user, @controller.current_v1_user
    end

  end
end
