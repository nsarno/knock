class SoftAdminController < ApplicationController
  # before_action do
  # 	authenticate_admin :soft
  # end
  before_action :soft_authenticate_admin  #:soft}


  def index
    head :ok
  end

end
