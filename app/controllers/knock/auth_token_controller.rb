require_dependency "knock/application_controller"

module Knock
  class AuthTokenController < ApplicationController
    before_action :authenticate!

    def create
      render json: { jwt: auth_token.token }, status: :created
    end

  private
    def authenticate!
      raise ActiveRecord::RecordNotFound unless user.authenticate(auth_params[:password])
    end

    def auth_token
      AuthToken.new payload: { user_id: user.id }
    end

    def user
      User.find_by! email: auth_params[:email]
    end

    def auth_params
      params.require(:auth).permit :email, :password
    end
  end
end
