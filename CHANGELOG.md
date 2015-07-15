# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased][unreleased]
### Added
- `Knock.token_lifetime` configuration variable
- `Knock.token_secret_signature_key` configuration variable
- `Knock.token_audience` configuration variable
- audience claim verification when decoding token
- `Knock.setup` method for configuration in `knock.rb` initializer
- generator for initializer (rails g knock:install)

## [1.0.0] - 2015-14-07
### Fixed
- Replaced all remaining references to deprecated gem name (Simsim)

## [1.0.0.rc1] - 2015-14-07
### Added
- AuthToken model
- AuthToken controller
- /auth_token route
- Authenticable module
