module Knock::Authenticatable

  def authenticate_for resource_class
    token = token_from_request_headers
    return head(:unauthorized) if token.nil?

    begin
      @resource = Knock::AuthToken.new(token: token).resource(resource_class)
      return head(:unauthorized) unless @resource
      define_current_resource_getter(resource_class)
    rescue
      return head(:unauthorized)
    end
  end

  private

  def method_missing(method, *args)
    prefix, *parts = method.to_s.split('_')
    if prefix == 'authenticate'
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
    self.class.send(:define_method, "current_#{resource_class.to_s.downcase}") do
      @resource
    end
  end

  # Not rescuing from NameError on purpose.
  # If trying to use `authenticate_user` but no `User` constant exists,
  # it makes more sense to raise NameError than NoMethodError.
  def constant_from_parts parts
    parts.map(&:capitalize).join.constantize
  end
end
