module Authenticable
  include AuthToken

  attr_reader :current_user

  def authenticate
    begin
      token = request.headers['Authorization'].split(' ').last
      payload, header = validate_token(token)
      @current_user = User.find(payload['user_id'])
    rescue
      head :unauthorized
    end
  end
end
