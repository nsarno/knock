# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## Unreleased
- adding config options for exception class

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

