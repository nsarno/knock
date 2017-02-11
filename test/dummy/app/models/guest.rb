class Guest
  def self.from_token_payload _payload
    # This is to simulate the use of `find_or_create`
    # on an AR model, regardless of the payload content
    new
  end
end
