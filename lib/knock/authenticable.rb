module Knock::Authenticable
  def authenticate
    warn "[DEPRECATION]: `authenticate` is deprecated. Please use `authenticate_user` instead."
    head(:unauthorized) unless authenticate_for(User)
  end

  def authenticate_for entity_class
    getter_name = "current_#{entity_class.to_s.underscore}"
    define_current_entity_getter(entity_class, getter_name)
    public_send(getter_name)
  end

  private

  def token
    params[:token] || token_from_request_headers || ''
  end

  def method_missing(method, *args)
    prefix, entity_name = method.to_s.split('_', 2)

    case prefix
    when 'authenticate'
      status_code = authenticate_entity(entity_name)
      if status_code != Knock.success_code
        unauthorized_entity(entity_name, status_code)
        false
      else
        true
      end
    when 'current'
      define_current_entity_getter(entity_name.camelize.constantize, method)
      public_send(method)
    else
      super
    end
  end

  def unauthorized_entity(entity_name, status_code)
    head(status_code || :unauthorized)
  end

  def token_from_request_headers
    unless request.headers['Authorization'].nil?
      request.headers['Authorization'].split.last
    end
  end
  # only authentificate method
  def authenticate_entity(entity_name)
    auth_token = validated_auth_token(token)
    if auth_token.blank?
      Knock.unauthorized_exception_code
    else
      if find_entity(auth_token, entity_name.camelize.constantize).nil?
        Knock.record_not_found_exception_code
      else
        Knock.success_code
      end
    end
  end
  # only current method
  def define_current_entity_getter entity_class, getter_name
    return if self.respond_to?(getter_name)

    memoization_var_name = "@_#{getter_name}"
    self.class.send(:define_method, getter_name) do
      unless instance_variable_defined?(memoization_var_name)
        auth_token = validated_auth_token(token)
        current = find_entity(auth_token, entity_class) if auth_token.present?

        instance_variable_set(memoization_var_name, current)
      end

      instance_variable_get(memoization_var_name)
    end
  end

  def find_entity(auth_token, entity_class)
    auth_token.entity_for(entity_class)
  rescue
    nil
  end

  def validated_auth_token(token)
    Knock::AuthToken.new(token: token)
  rescue
    nil
  end
end
