module Simsim
  class ApplicationController < ActionController::Base
    include AuthToken

    rescue_from ActiveRecord::RecordNotFound, with: :not_found
  private

    def not_found
      head :not_found
    end
  end
end
