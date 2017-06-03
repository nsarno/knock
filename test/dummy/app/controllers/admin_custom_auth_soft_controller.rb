class AdminCustomAuthSoftController < ApplicationController
  before_action :soft_authenticate_admin
  
  def index
    head :ok
  end

  private
  def soft_authenticate_admin
    set_soft_authenticate_for Admin
  end
end
