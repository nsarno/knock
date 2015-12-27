module Knock::Authenticable
  attr_reader :current_user

  def authenticate
    begin
      token = params[:token] || request.headers['Authorization'].split(' ').last
      @current_user = Knock::AuthToken.new(token: token).current_user
    rescue
      head :unauthorized
    end
  end
end
