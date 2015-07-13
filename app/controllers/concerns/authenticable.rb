module Authenticable
  include AuthToken

  attr_accessor :current_user
  attr_accessor :expiration_time

  def authenticate
    begin
      token = request.headers['Authorization'].split(' ').last
      payload, header = validate_token(token)
      @current_user = User.find(payload['user_id'])
    rescue
      head :unauthorized
    end
  end

  def expiration_time
    @expiration_time || 1.day
  end
end
