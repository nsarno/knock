module Knock
  class ApplicationController < ActionController::Base
    rescue_from Knock.record_not_found_error_class, with: :not_found

  private

    def not_found
      head :not_found
    end
  end
end
