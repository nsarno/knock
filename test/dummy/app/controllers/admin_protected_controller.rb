class AdminProtectedController < ApplicationController
  before_action :authenticate_trump

  def index
    head :ok
  end
end
