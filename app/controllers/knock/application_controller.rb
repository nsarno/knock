module Knock
  class ApplicationController < ActionController::Base
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

    def not_found
      head :not_found
    end
  end
end
