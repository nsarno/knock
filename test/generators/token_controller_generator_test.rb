require "test_helper"

class TokenControllerGeneratorTest < Rails::Generators::TestCase
  include GeneratorsTestHelper

  tests Knock::TokenControllerGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))

  setup :prepare_destination
  setup :copy_routes

  test "assert all files are properly created" do
    run_generator ['User']
    assert_file "app/controllers/user_token_controller.rb"

    run_generator ['Admin']
    assert_file "app/controllers/user_token_controller.rb"
  end
end
