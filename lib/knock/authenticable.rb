module Knock::Authenticable
  attr_reader :current_user

  def authenticate(key: nil)
    begin
      token = request.headers['Authorization'].split(' ').last
      @current_user = Knock::AuthToken.new(token: token, decrypt_key: key).current_user
    rescue
      head :unauthorized
    end
  end
end
