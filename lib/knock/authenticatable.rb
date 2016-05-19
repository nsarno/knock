module Knock::Authenticatable

  def authenticate_for resource_class
    token = token_from_request_headers
    return nil if token.nil?

    begin
      @resource = Knock::AuthToken.new(token: token).resource(resource_class)
      define_current_resource_getter(resource_class)
      @resource
    rescue
      nil
    end
  end

  private

  def method_missing(method, *args)
    prefix, *parts = method.to_s.split('_')
    case prefix
    when 'authenticate'
      resource_class = constant_from_parts(parts)
      head(:unauthorized) unless send(:authenticate_for, resource_class)
    when 'current'
      resource_class = constant_from_parts(parts)
      send(:authenticate_for, resource_class)
    else
      super
    end
  end

  def token_from_request_headers
    unless request.headers['Authorization'].nil?
      request.headers['Authorization'].split.last
    end
  end

  def define_current_resource_getter resource_class
    getter_name = "current_#{resource_class.to_s.underscore}"
    unless self.respond_to?(getter_name)
      self.class.send(:define_method, getter_name) do
        @resource ||= nil
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
