require 'test_helper'

module Knock
  private

  def self.const_warning(const_name)
    # avoid output to stderr when testing deprecated constants
  end
end

class KnockTest < ActiveSupport::TestCase
  test 'setup block yields self' do
    Knock.setup do |config|
      assert_equal Knock, config
    end
  end

  test 'Knock::Authenticable is deprecated' do
    assert_equal Knock::Authenticable, Knock::Authenticatable
    assert_equal Knock.deprecated_constants[:Authenticable].nil?, false
  end
end
