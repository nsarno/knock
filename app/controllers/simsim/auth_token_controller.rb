require_dependency "simsim/application_controller"

module Simsim
  class AuthTokenController < ApplicationController
    before_action :authenticate!

    def create
      render json: { jwt: auth_token }, status: :created
    end

  private
    def authenticate!
      raise ActiveRecord::RecordNotFound unless user.authenticate(auth_params[:password])
    end

    def auth_token
      self.issue_token(user_id: user.id, exp: expiration_time)
    end

    def expiration_time
      self.token_lifetime.from_now.to_i
    end

    def user
      User.find_by! email: auth_params[:email]
    end

    def auth_params
      params.require(:auth).permit :email, :password
    end
  end
end
