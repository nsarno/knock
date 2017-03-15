module V1
  class User < ActiveRecord::Base
    has_secure_password
  end
end