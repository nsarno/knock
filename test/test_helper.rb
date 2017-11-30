require 'knock'
require 'simplecov'
require 'active_support/all'
require 'minitest/autorun'
require 'minitest/reporters'

reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

SimpleCov.start

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new



module Knock
  class MyCustomException < StandardError
  end
end

# Make sure knock global configuration is reset before every tests
# to avoid order dependent failures.
class ActiveSupport::TestCase
  setup :reset_knock_configuration

  private

  def reset_knock_configuration
    Knock.token_signature_algorithm = 'HS256'
    Knock.token_secret_signature_key = -> { "secret" }
    Knock.token_public_key = nil
    Knock.token_audience = nil
    Knock.token_lifetime = 1.day
  end
end
