# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [1.2.0] - 2015-07-16
### Changed
- Introduce a way to configure how the current_user is retrieved when
  validating a token. (#1)
- Use "sub" claim to store the user id by default instead of "user_id"

### Fixed
- Decode auth0_client_secret in default configuration for Auth0

## [1.1.0] - 2015-07-15

## [1.1.0.rc1] - 2015-07-15
### Added
- `Knock.token_lifetime` configuration variable
- `Knock.token_secret_signature_key` configuration variable
- `Knock.token_audience` configuration variable
- audience claim verification when decoding token
- `Knock.setup` method for configuration in `knock.rb` initializer
- generator for initializer (rails g knock:install)

## [1.0.0] - 2015-07-14
### Fixed
- Replaced all remaining references to deprecated gem name (Simsim)

## [1.0.0.rc1] - 2015-07-14
### Added
- AuthToken model
- AuthToken controller
- /auth_token route
- Authenticable module
