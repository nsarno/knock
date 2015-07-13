module Simsim
  class ApplicationController < ActionController::Base
    include AuthToken

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    attr_accessor :expiration_time    

    def expiration_time
      @expiration_time || 1.day
    end

  private

    def not_found
      head :not_found
    end
  end
end
