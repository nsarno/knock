class User < ActiveRecord::Base
  has_secure_password

  def self.find_for_authentication payload
    self.find payload['sub']
  end
end
