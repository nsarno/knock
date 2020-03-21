# frozen_string_literal: true

module Knock
  # Include this module in your controller to enable authentication
  # for your endpoint.
  #
  # e.g.
  # Calling `authenticate_jwt_user` will try to find a valid `User` based on
  # the token payload.
  module Authenticable
    private

    def jwt_token
      params[:jwt_token] || jwt_token_from_request_headers
    end

    def jwt_token_from_request_headers
      request.headers["Authorization"]&.split&.last
    end

    def authenticate_jwt_for(entity_class)
      getter_name = "current_jwt_#{entity_class.to_s.parameterize.underscore}"
      define_current_entity_getter(entity_class, getter_name)
      # public_send(getter_name)
      __send__(getter_name)
    end

    def method_missing(method, *args)
      prefix, entity_name = method.to_s.split("_", 2)
      case prefix
      when "authenticate_jwt"
        unauthorized_entity(entity_name) unless authenticate_jwt_entity(entity_name)
      when "current_jwt"
        authenticate_jwt_entity(entity_name)
      else
        super
      end
    end

    def respond_to_missing?(method, *)
      prefix, = method.to_s.split("_", 2)
      case prefix
      when "authenticate_jwt"
        true
      else
        super
      end
    end

    def authenticate_jwt_entity(entity_name)
      return unless jwt_token

      entity_class = entity_name.camelize.constantize
      authenticate_jwt_for(entity_class)
    end

    def unauthorized_entity(_entity_name)
      head(:unauthorized)
    end

    # Dynamically defines a method similar to the example below.
    #
    # def current_jswt_user
    #   @_current_user ||= fetch_entity_from_jwt_token(User)
    # end
    def define_current_entity_getter(entity_class, getter_name)
      return if respond_to?(getter_name)

      memoization_var_name = "@_#{getter_name}"
      self.class.send(:define_method, getter_name) do
        unless instance_variable_defined?(memoization_var_name)
          current = fetch_entity_from_jwt_token(entity_class)
          instance_variable_set(memoization_var_name, current)
        end
        instance_variable_get(memoization_var_name)
      end
    end

    def fetch_entity_from_jwt_token(entity_class)
      Knock::AuthToken.new(token: token).entity_for(entity_class)
    rescue Knock.not_found_exception_class, JWT::DecodeError, JWT::EncodeError
      nil
    end
  end
end
