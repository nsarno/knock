class Admin < ActiveRecord::Base
  has_secure_password

  def self.from_token_request request
    email = request.params["auth"] && request.params["auth"]["email"]
    self.find_by email: email
  end

  def self.from_token_payload payload
    self.find payload["sub"]
  end

  def to_token_payload
    {sub: id}
  end
end
