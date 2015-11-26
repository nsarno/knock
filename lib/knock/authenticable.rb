module Knock::Authenticable
  attr_reader :current_user

  def authenticate
    begin
      token = request.headers['Authorization'].split(' ').last
      pubkey = File.exists?('config/pubkey.pem') ?
                              OpenSSL::PKey::RSA.new(File.read('config/pubkey.pem')) :
                              nil
      @current_user = Knock::AuthToken.new(token: token, decrypt_key: pubkey).current_user
    rescue
      head :unauthorized
    end
  end
end
