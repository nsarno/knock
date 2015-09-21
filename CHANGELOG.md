# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [2.0.0] - Unreleased

You can now handle multiple user models other than User (useful if you have
an Admin model for example).
Also some customization has been moved from the initializer to the model which gives more flexibility.

### Added
- Define `find_for_authentication` in a resource model (eg: User) to customize the way
the resource is fetched from the database when decoding the token. This deprecates
the use of `Knock.current_user_from_token`.
- Define `find_for_token_creation` in a resource model (eg: User) to customize the way
the resource is fetched from the database when generating an authentication token. This deprecates
the use of `Knock.current_user_from_handle`.
- Authenticate any resource (eg: `User`, `Admin`, ...) by including the
`Knock::Authenticatable` module and calling the corresponding before action
(eg: `authenticate_user`, `authenticate_admin`, ...).
- Generator for token controller (for signing in): `knock:token_controller` .
- Config options for exception class

### Changed
- Use `Knock::Authenticatable` instead of `Knock::Authenticable`.
- To secure controllers, use `authenticate_user` instead of `authenticate`.

### Removed
- `Knock.current_user_from_handle`
- `Knock.current_user_from_token`
- No need to mount the engine anymore.


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

