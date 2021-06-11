class Admin < ActiveRecord::Base
  include Knock::Tokenizable

  has_secure_password

  def self.from_token_request request
    email = request.params["auth"] && request.params["auth"]["email"]
    self.find_by email: email
  end
end
