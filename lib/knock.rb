require "knock/engine"

module Knock
  # How long before a token is expired. If nil is provided,
  # token will last forever.
  mattr_accessor :token_lifetime
  self.token_lifetime = 1.day

  # Configure the audience claim to identify the recipients that the token
  # is intended for.
  mattr_accessor :token_audience
  self.token_audience = nil

  # Configure the algorithm used to encode the token
  mattr_accessor :token_signature_algorithm
  self.token_signature_algorithm = "HS256"

  # Configure the key used to sign tokens.
  mattr_accessor :token_secret_signature_key
  self.token_secret_signature_key = -> do
    if Rails.application.respond_to?(:secret_key_base)
      Rails.application.secret_key_base
    else
      Rails.application.secrets.secret_key_base
    end
  end

  # Configure the public key used to decode tokens, when required.
  mattr_accessor :token_public_key
  self.token_public_key = nil

  # Configure the exception to be used when user cannot be found.
  mattr_accessor :not_found_exception_class_name
  self.not_found_exception_class_name = "ActiveRecord::RecordNotFound"

  def self.not_found_exception_class
    not_found_exception_class_name.to_s.constantize
  end

  # Default way to setup Knock. Run `rails generate knock:install` to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end
end
