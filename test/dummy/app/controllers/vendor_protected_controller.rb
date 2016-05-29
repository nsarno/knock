class VendorProtectedController < ApplicationController
  before_action :authenticate_vendor, only: [:index]
  before_action :some_missing_method, only: [:show]

  def index
    head :ok
  end

  def show
  end
end
