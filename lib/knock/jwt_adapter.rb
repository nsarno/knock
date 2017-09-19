module Knock
  class JwtAdapter
    def decode(token, options)
      payload, _ = JWT.decode token.to_s, decode_key, true, options

      payload
    end

    def encode(payload)
      JWT.encode payload, secret_key, Knock.token_signature_algorithm
    end

    private

    def secret_key
      Knock.token_secret_signature_key.call
    end

    def decode_key
      Knock.token_public_key || secret_key
    end
  end
end
