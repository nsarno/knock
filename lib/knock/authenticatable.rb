module Knock::Authenticatable

  def authenticate_for resource_class
    token = token_from_request_headers
    return head(:unauthorized) if token.nil?

    begin
      @resource = Knock::AuthToken.new(token: token).resource(resource_class)
      return head(:unauthorized) unless @resource
      define_current_resource_getter(resource_class)
    rescue
      false
    end
  end

  private

  def method_missing(method, *args)
    prefix, *parts = method.to_s.split('_')
    
    if prefix == 'authenticate'
      parts = parts.join("_").split("_or_")

      for part in parts
        resource_class = constant_from_parts(part)
        return if send(:authenticate_for, resource_class)
      end

      return head(:unauthorized)
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
    parts.split('_').map(&:capitalize).join.constantize
  end
end
