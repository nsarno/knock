Knock.setup do |config|

  ## [DEPRECATED]
  ## This is deprecated in favor of `User.from_token_request`.
  ##
  ## User handle attribute
  ## ---------------------
  ##
  ## The attribute used to uniquely identify a user.
  ##
  ## Default:
  # config.handle_attr = :email

  ## [DEPRECATED]
  ## This is deprecated in favor of `User.from_token_request`.
  ##
  ## Current user retrieval from handle when signing in
  ## --------------------------------------------------
  ##
  ## This is where you can configure how to retrieve the current user when
  ## signing in.
  ##
  ## Knock uses the `handle_attr` variable to retrieve the handle from the
  ## AuthTokenController parameters. It also uses the same variable to enforce
  ## permitted values in the controller.
  ##
  ## You must raise an exception if the resource cannot be retrieved.
  ## The type of the exception is configured in config.not_found_exception_class_name,
  ## and it is ActiveRecord::RecordNotFound by default
  ##
  ## Default:
  # config.current_user_from_handle = -> (handle) { User.find_by! Knock.handle_attr => handle }

  ## [DEPRECATED]
  ## This is depreacted in favor of `User.from_token_payload`.
  ##
  ## Current user retrieval when validating token
  ## --------------------------------------------
  ##
  ## This is how you can tell Knock how to retrieve the current_user.
  ## By default, it assumes you have a model called `User` and that
  ## the user_id is stored in the 'sub' claim.
  ##
  ## You must raise an exception if the resource cannot be retrieved.
  ## The type of the exception is configured in config.not_found_exception_class_name,
  ## and it is ActiveRecord::RecordNotFound by default
  ##
  ## Default:
  # config.current_user_from_token = -> (claims) { User.find claims['sub'] }


  ## Expiration claim
  ## ----------------
  ##
  ## How long before a token is expired. If nil is provided, token will
  ## last forever.
  ##
  ## Default:
  # config.token_lifetime = 1.day


  ## Audience claim
  ## --------------
  ##
  ## Configure the audience claim to identify the recipients that the token
  ## is intended for.
  ##
  ## Default:
  # config.token_audience = nil

  ## If using Auth0, uncomment the line below
  # config.token_audience = -> { Rails.application.secrets.auth0_client_id }

  ## Signature algorithm
  ## -------------------
  ##
  ## Configure the algorithm used to encode the token
  ##
  ## Default:
  # config.token_signature_algorithm = 'HS256'

  ## Signature key
  ## -------------
  ##
  ## Configure the key used to sign tokens.
  ##
  ## Default:
  # config.token_secret_signature_key = -> { Rails.application.secrets.secret_key_base }

  ## If using Auth0, uncomment the line below
  # config.token_secret_signature_key = -> { JWT.base64url_decode Rails.application.secrets.auth0_client_secret }

  ## Public key
  ## ----------
  ##
  ## Configure the public key used to decode tokens, if required.
  ##
  ## Default:
  # config.token_public_key = nil

  ## Exception Class
  ## ---------------
  ##
  ## Configure the exception to be used when user cannot be found.
  ##
  ## Default:
  # config.not_found_exception_class_name = 'ActiveRecord::RecordNotFound'
end
