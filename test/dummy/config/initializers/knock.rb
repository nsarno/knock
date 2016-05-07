Knock.setup do |config|

  ## Expiration claim
  ## ----------------
  ##
  ## How long before a token is expired.
  ##
  ## Default:
  # config.token_lifetime = 1.day

  ## Custom claim
  ## ------------
  ##
  ## Add the cusom claims you want in the token's payload, it should be a Hash.
  ## sub (resource id) will always be included (and you can't overwrite it)
  ##
  ## Default:
  # config.custom_claims = -> (resource) { { roles: resource.roles } }
  config.custom_claims = -> (resource) { { name: resource.name } if resource.respond_to?(:name) }


  ## Audience claim
  ## --------------
  ##
  ## Configure the audience claim to indentify the recipients that the token
  ## is intended for.
  ##
  ## Default:
  # config.token_audience = nil

  ## If using Auth0, uncomment the line below
  # config.token_audience = -> { Rails.application.secrets.auth0_client_id }


  ## Signature key
  ## -------------
  ##
  ## Configure the key used to sign tokens.
  ##
  ## Default:
  # config.token_secret_signature_key = -> { Rails.application.secrets.secret_key_base }

  ## If using Auth0, uncomment the line below
  # config.token_secret_signature_key = -> { JWT.base64url_decode Rails.application.secrets.auth0_client_secret }

end
