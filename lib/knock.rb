require "knock/engine"

module Knock

  mattr_accessor :handle_attr
  self.handle_attr = :email

  mattr_accessor :current_user_from_handle
  self.current_user_from_handle = -> handle { User.find_by! Knock.handle_attr => handle }

  mattr_accessor :current_user_from_token
  self.current_user_from_token = -> claims { User.find claims['sub'] }

  mattr_accessor :token_lifetime
  self.token_lifetime = 1.day

  mattr_accessor :token_audience
  self.token_audience = nil

  mattr_accessor :token_secret_signature_key
  self.token_secret_signature_key = -> { Rails.application.secrets.secret_key_base }

  # Default way to setup Knock. Run `rails generate knock:install` to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end
end
