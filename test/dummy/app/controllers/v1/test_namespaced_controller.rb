module V1
  class TestNamespacedController < ApplicationController

    before_action :authenticate_v1_user

    def index
      head :ok
    end

    private

    def authenticate_v1_user
      authenticate_for V1::User
    end

  end
end
