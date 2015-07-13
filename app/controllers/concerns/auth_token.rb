require 'jwt'

module AuthToken  
  def issue_token payload
    JWT.encode payload, Rails.application.secrets.secret_key_base, 'HS256'
  end

  def validate_token token
    JWT.decode token, Rails.application.secrets.secret_key_base
  end
end
