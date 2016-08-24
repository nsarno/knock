class CustomUnauthorizedEntityController < ApplicationController
  before_action :authenticate_user

  def index
    head :ok
  end

  private

  def unauthorized_entity(_entity, _status_code)
    head :not_found
  end
end
