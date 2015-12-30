module Knock::Authenticable
  def current_user
    @current_user ||= begin
      token = params[:token] ||
        request.headers['Authorization'].match(/^Bearer (.*)$/)[1]

      Knock::AuthToken.new(token: token).current_user
    rescue
      nil
    end
  end

  def authenticate
    head :unauthorized unless current_user
  end
end
