require "test_helper"

module Knock
  class GetterNameTest < ActiveSupport::TestCase
    test "check simple model names" do
      getter_name = GetterName.new("Test").cleared
      assert_equal getter_name, "current_test"
    end

    test "check pascal cased names" do
      getter_name = GetterName.new("TestModel").cleared
      assert_equal getter_name, "current_test_model"
    end

    test "check namespaced model names" do
      getter_name = GetterName.new("Test::Model").cleared
      assert_equal getter_name, "current_test_model"
    end

    test "check double namespaced model names" do
      getter_name = GetterName.new("Test::Double::Model").cleared
      assert_equal getter_name, "current_test_double_model"
    end
  end
end
