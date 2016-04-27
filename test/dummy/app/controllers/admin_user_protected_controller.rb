class AdminUserProtectedController < ApplicationController
  before_action :authenticate_admin_user

  def index
    head :ok
  end
end
