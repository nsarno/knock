class Admin < ActiveRecord::Base
  has_secure_password

  def self.find_for_token_creation request
    params = request.params["auth"]
    self.find_by email: params["email"]
  end

  def self.find_for_authentication payload
    self.find payload["sub"]
  end

  def to_token_payload
    {sub: id}
  end
end
