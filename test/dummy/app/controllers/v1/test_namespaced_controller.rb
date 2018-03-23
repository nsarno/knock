module V1
  class TestNamespacedController < ApplicationController

    before_action :check_authentication!

    def index
      head :ok
    end

    private

    def check_authentication!
      unauthorized_entity('v1/user') unless authenticate_entity('v1/user')
    end

  end
end
