# frozen_string_literal: true
module Knock
  # Include this module in your entity class (e.g. User)
  # for token serialization and deserialization.
  module Tokenizable
    def self.included(base)
      base.extends ClassMethods
    end

    module ClassMethods
      def from_token_payload(payload)
        find(payload["sub"])
      end

      def from_token(token)
        auth_token = AuthToken.new(token: token)
        from_token_payload(auth_token.payload)
      end
    end

    def to_token_payload
      { sub: @object.id }
    end

    def to_token
      AuthToken.new(payload: to_token_payload).token
    end
  end
end
