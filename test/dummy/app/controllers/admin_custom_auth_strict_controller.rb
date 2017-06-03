class AdminCustomAuthStrictController < ApplicationController
  before_action :authenticate_admin
  

  def index
    head :ok
  end

  private
  def authenticate_admin
    set_authenticate_for Admin
  end
end
