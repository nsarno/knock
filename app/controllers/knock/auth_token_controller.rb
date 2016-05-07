require_dependency "knock/application_controller"

module Knock
  class AuthTokenController < ApplicationController
    before_action :authenticate!

    def create
      render json: { jwt: auth_token.token }, status: :created
    end

  private
    def authenticate!
      raise Knock.not_found_exception_class unless user.authenticate(auth_params[:password])
    end

    def auth_token
      claims = { sub: user.id }
      custom_claims = Knock.custom_claims.call(user)
      merged_claims = custom_claims.is_a?(Hash) ? custom_claims.merge(claims) : claims

      AuthToken.new payload: merged_claims
    end

    def user
      Knock.current_user_from_handle.call auth_params[Knock.handle_attr]
    end

    def auth_params
      params.require(:auth).permit Knock.handle_attr, :password
    end
  end
end
