require "knock/engine"

module Knock

  # Define the duration of a token validity.
  # The "exp" property of the token is equal to:
  #   (time at token creation) + (token lifetime)
  # => token_lifetime.from_now.to_i
  mattr_accessor :token_lifetime
  self.token_lifetime = 1.day

  # Define the duration of a token validity.
  # The "exp" property of the token is equal to:
  #   (time at token creation) + (token lifetime)
  # => token_lifetime.from_now.to_i
  mattr_accessor :token_secret_signature_key
  self.token_secret_signature_key = Rails.application.secrets.secret_key_base

  # Default way to setup Knock. Run rails generate knock_install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end
end
