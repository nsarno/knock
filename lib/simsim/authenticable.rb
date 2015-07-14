module Simsim::Authenticable
  attr_reader :current_user

  def authenticate
    begin
      token = request.headers['Authorization'].split(' ').last
      payload, header = Simsim::AuthToken.new(token: token).validate!
      @current_user = User.find(payload['user_id'])
    rescue
      head :unauthorized
    end
  end
end
