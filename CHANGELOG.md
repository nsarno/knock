# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [2.0.0] - Unreleased
## Added
- Possibility to have permanent tokens

### Upgrade from 1.3

*For everyone*

- Change gem version in Gemfile from '~> 1.3' to '~> 2.0' and run `bundle install`.
- Replace `authenticate` filters with `authenticate_user`.
- Remove this line from   `config/routes.rb`: `mount Knock::Engine => "/knock"`
- Run the token controller generator: `rails g knock:token_controller user`

*For special configurations*

If you have a custom value set for `Knock.handle_attr` AND/OR `Knock.current_user_from_handle`:

- Remove it from the `config/initializers/knock.rb`
- Implement the `User.find_for_token_creation` method in `user.rb`:

Example to use `:username` instead of `:email`:

```ruby
def self.find_for_token_creation params
  User.find_by username: params[:username]
end
```

This method takes the parameters from the controller (`params.require(:auth).permit!`) in argument.
If the user cannot be found, it should return a falsy value (`nil` or `false`).
If you raise an exception here, it is your responsability to rescue it and act accordingly.

If you have a custom value set for `Knock.current_user_from_token`:

- Remove it from the `config/initializers/knock.rb`.
- Implement the `User.find_for_authentication` method in `user.rb`:

Example to retrieve the user id from a field other than 'sub' in the token payload:

```ruby
def self.find_for_authentication payload
  User.find payload['custom_field']
end
```

This method takes the token payload in argument.
If the user cannot be found, it should return a falsly value (`nil` or `false`) or raise an exception.
In both case, knock will respond with `head :unauthorized`.

### Added
- Handle multiple types of user models (useful if you need admin users for example).
- Token controller generator (for signing in): `knock:token_controller`. Multiple user models means we need one token controller per user type.

### Changed
- Rename `Knock::Authenticable` to `Knock::Authenticatable`.
- Rename `authenticate` to `authenticate_user`.
- Use class method `find_for_authentication` in the user model instead of `Knock.current_user_from_token`.
- Use class method `find_for_token_creation` in the user model instead of `Knock.current_user_from_handle` and `Knock.handle_attr`.

### Removed
- `Knock.handle_attr`
- `Knock.current_user_from_handle`
- `Knock.current_user_from_token`
- No need to mount the engine anymore.

## [1.4.1] - 2016-01-08
### Fixed
- Use lambda for audience verification

## [1.4.0] - 2016-01-02
### Changed
- Allow use of rails versions above 4.2
- Allow use of different encoding algorithm
- Travis integration
- Contribution guidelines

### Fixed
- Audience verification in token

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
