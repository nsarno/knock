class SoftAdminController < ApplicationController
  before_action :soft_authenticate_admin


  def index
    head :ok
  end

end
