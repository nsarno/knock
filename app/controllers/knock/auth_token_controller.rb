require_dependency "knock/application_controller"

module Knock
  class AuthTokenController < ApplicationController
    before_action :authenticate

    def create
      render json: auth_token, status: :created
    end

  private
    def authenticate
      unless entity.present? && entity.authenticate(auth_params[:password])
        raise Knock.not_found_exception_class
      end
    end

    def auth_token
      AuthToken.new payload: { sub: entity.id }
    end

    def entity
      @entity ||=
        if self.class.name == "Knock::AuthTokenController"
          warn "[DEPRECATION]: Routing to `AuthTokenController` directly is deprecated. Please use `<Entity Name>TokenController` inheriting from it instead. E.g. `UserTokenController`"
          warn "[DEPRECATION]: Relying on `Knock.current_user_from_handle` is deprecated. Please implement `User#find_for_token_creation` instead."
          Knock.current_user_from_handle.call auth_params[Knock.handle_attr]
        else
          if entity_class.respond_to? :find_for_token_creation
            entity_class.find_for_token_creation request
          else
            entity_class.find_by email: auth_params[:email]
          end
        end
    end

    def entity_class
      entity_name.constantize
    end

    def entity_name
      self.class.name.split('TokenController').first
    end

    def auth_params
      params.require(:auth).permit Knock.handle_attr, :password
    end
  end
end
