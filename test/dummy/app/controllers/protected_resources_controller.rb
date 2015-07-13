class ProtectedResourcesController < ApplicationController
  before_action :authenticate

  def index
    head :ok
  end
end
