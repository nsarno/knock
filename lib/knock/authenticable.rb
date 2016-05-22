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
    prefix, *parts = method.to_s.split('_')
    case prefix
    when 'authenticate'
      entity_class = constant_from_parts(parts)
      head(:unauthorized) unless send(:authenticate_for, entity_class)
    when 'current'
      entity_class = constant_from_parts(parts)
      send(:authenticate_for, entity_class)
    else
      super
    end
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

  # Not rescuing from NameError on purpose.
  # If trying to use `authenticate_user` but no `User` constant exists,
  # it makes more sense to raise NameError than NoMethodError.
  def constant_from_parts parts
    parts.map(&:capitalize).join.constantize
  end
end
