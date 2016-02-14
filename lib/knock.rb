require "knock/engine"
require "knock/authenticatable"

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

  mattr_accessor :token_signature_algorithm
  self.token_signature_algorithm = 'HS256'

  mattr_accessor :token_secret_signature_key
  self.token_secret_signature_key = -> { Rails.application.secrets.secret_key_base }

  mattr_accessor :token_public_key
  self.token_public_key = nil

  # Default way to setup Knock. Run `rails generate knock:install` to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end

  def self.const_missing(const_name)
    valid_const = deprecated_constants[const_name]
    const_warning(const_name) if valid_const
    valid_const || super
  end

  def self.deprecated_constants
    {
      Authenticable: Authenticatable,
    }
  end

  private

  def self.const_warning(const_name)
    @const_warning ||= false
    unless @const_warning
      $stderr.puts "WARNING: Deprecated reference to constant '#{const_name}'"
      $stderr.puts "Use '#{deprecated_constants[const_name]}' instead"
    end
    @const_warning = true
  end
end
