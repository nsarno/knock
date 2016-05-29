module Knock::Authenticable
  def authenticate
    warn "[DEPRECATION]: `authenticate` is deprecated. Please use `authenticate_user` instead."
    head(:unauthorized) unless authenticate_for(User)
  end

  def authenticate_for entity_class
    token = params[:token] || token_from_request_headers
    return nil if token.nil?

    begin
      @entity = Knock::AuthToken.new(token: token).entity_for(entity_class)
      define_current_entity_getter(entity_class)
      @entity
    rescue
      nil
    end
  end

  private

  def method_missing(method, *args)
    prefix, entity_name = method.to_s.split('_', 2)
    case prefix
    when 'authenticate'
      head(:unauthorized) unless authenticate_entity(entity_name)
    when 'current'
      authenticate_entity(entity_name)
    else
      super
    end
  end

  def authenticate_entity(entity_name)
    entity_class = entity_name.camelize.constantize
    send(:authenticate_for, entity_class)
  end

  def token_from_request_headers
    unless request.headers['Authorization'].nil?
      request.headers['Authorization'].split.last
    end
  end

  def define_current_entity_getter entity_class
    getter_name = "current_#{entity_class.to_s.underscore}"
    unless self.respond_to?(getter_name)
      self.class.send(:define_method, getter_name) do
        @entity ||= nil
      end
    end
  end
end
