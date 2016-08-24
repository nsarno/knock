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

  mattr_accessor :token_signature_algorithm
  self.token_signature_algorithm = 'HS256'

  mattr_accessor :token_secret_signature_key
  self.token_secret_signature_key = -> { Rails.application.secrets.secret_key_base }

  mattr_accessor :token_public_key
  self.token_public_key = nil

  mattr_accessor :unauthorized_exception_code
  self.unauthorized_exception_code = 401

  mattr_accessor :record_not_found_exception_code
  self.record_not_found_exception_code = 404

  mattr_accessor :not_found_exception_class_name
  self.not_found_exception_class_name = 'ActiveRecord::RecordNotFound'

  def self.not_found_exception_class
    not_found_exception_class_name.to_s.constantize
  end

  def self.success_code
    200
  end

  # Default way to setup Knock. Run `rails generate knock:install` to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end
end
