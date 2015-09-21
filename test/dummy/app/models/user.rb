class User < ActiveRecord::Base
  has_secure_password

  def self.find_with_payload payload
    self.find payload['sub']
  end
end
