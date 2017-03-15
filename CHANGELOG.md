# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [2.1.1] - 2017-02-11
### Fixed
- Stop trying to retrieve user from empty payload when no token is given

## [2.1] - 2017-01-31
### Fixed
- Parsing of token controller to handle namespaces correctly

### Added
- Configurable default validations by adding `verify_options` parameter to AuthToken initializer


## [2.0] - 2016-10-23
### Added
- Configurable unauthorized response by overriding `Authenticable#unauthorized_entity`

### Removed
- Deprecated features (see deprecated features in version 1.5)

## [1.5] - 2016-05-29
### Added
- Exception configuration option `Knock.not_found_exception_class_name`
- Multiple entity authentication (e.g. User, Admin, etc)
- Possibility to have permanent tokens
- Adding config options for exception class
- Generator for token controller. E.g. `rails g knock:token_controller user`

### Changed
- Deprecated `Authenticable#authenticate` in favor of `Authenticable#authenticate_user`
- Deprecated use of `Knock.current_user_from_token` in favor of `User.from_token_payload`
- Deprecated use of direct route to `AuthTokenController` in favor of generating  a token controller
- No need to mount the engine in `config/routes.rb` anymore

## [1.4.2] - 2016-01-29
### Fixed
- Allow use of any or no prefix in authorization header.
This fixes an unwanted breaking change introduced in `1.4.0` forcing the use
of the `Bearer` prefix.

## [1.4.1] - 2016-01-08
### Fixed
- Use lambda for audience verification

## [1.4.0] - 2016-01-02
### Changed
- Allow use of rails versions above 4.2

### Added
- Travis integration
- Contribution guidelines
- URL authentication
- Allow use of different encoding algorithm
- Expose `current_user` in the controllers without authenticating

### Fixed
- Audience verification in token
- Use lambda syntax compatible with older ruby versions
- A few typos

## [1.3.0] - 2015-07-23
### Added
- Configuration option for how the current_user is retrieved when signing in.
- Configuration option for the handle attribute (email by default).

## [1.2.0] - 2015-07-16
### Added
- Configuration option for how the current_user is retrieved when validating
  a token. (#1)

### Changed
- Use "sub" claim to store the user id by default instead of "user_id". (#1)

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

## [1.0.0.rc1] - 2015-07-14
### Added
- `Knock::Authenticable` to secure endpoints with `before_action :authenticate`
- `AuthToken` model provides JWT encapsulation
- `AuthTokenController` provides out of the box sign in implementation
