module Knock
  class AuthTokenController < ActionController::Base
    before_action :authenticate

    def create
      render json: auth_token, status: :created
    end

  private
    def authenticate
      unless resource.present? && resource.authenticate(auth_params[:password])
        head :not_found
      end
    end

    def auth_token
      AuthToken.new payload: { sub: resource.id }
    end

    def auth_params
      params.require(:auth).permit!
    end

    def resource
      @resource ||= 
        if resource_class.respond_to? :find_for_token_creation
          resource_class.find_for_token_creation auth_params
        else
          resource_class.find_by email: auth_params[:email]
        end
    end

    def resource_class
      resource_name.constantize
    end

    def resource_name
      self.class.name.split('TokenController').first
    end
  end
end
