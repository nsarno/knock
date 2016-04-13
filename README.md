# knock
[![Gem Version](https://badge.fury.io/rb/knock.svg)](http://badge.fury.io/rb/knock)
[![Build Status](https://travis-ci.org/nsarno/knock.svg)](https://travis-ci.org/nsarno/knock)
[![Test Coverage](https://codeclimate.com/github/nsarno/knock/badges/coverage.svg)](https://codeclimate.com/github/nsarno/knock/coverage)
[![Code Climate](https://codeclimate.com/github/nsarno/knock/badges/gpa.svg)](https://codeclimate.com/github/nsarno/knock)
[![Dependency Status](https://gemnasium.com/nsarno/knock.svg)](https://gemnasium.com/nsarno/knock)

Seamless JWT authentication for Rails API

## Description

Knock is an authentication solution for Rails API-only application based on JSON Web Tokens.

### What are JSON Web Tokens?

[![JWT](http://jwt.io/assets/badge.svg)](http://jwt.io/)

### Why should I use this?

- It's lightweight.
- It's tailored for Rails API-only application.
- It's [stateless](https://en.wikipedia.org/wiki/Representational_state_transfer#Stateless).
- It works out of the box with [Auth0](https://auth0.com/docs/server-apis/rails).

### Is this gem going to be maintained?

Yes.

### Upcoming features & improvements

- Easy way to authenticate multiple user types (User, Admin, ...)
- Remove ActiveRecord dependency

Really want some feature? Don't hesitate to open an issue :)

## Getting Started

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'knock'
```

And then execute:

    $ bundle install

Finally, run the install generator:

    $ rails generate knock:install

It will create the following initializer `config/initializers/knock.rb`.
This file contains all the informations about the existing configuration options.

### Requirements

Knock makes one assumption about your user model:

It must have an `authenticate` method, similar to the one added by [has_secure_password](http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password).

```ruby
class User < ActiveRecord::Base
  has_secure_password
end
```

Using `has_secure_password` is recommended, but you don't have to as long as your user model implements an `authenticate` instance method with the same behavior.

### Usage

Mount the `Knock::Engine` in your `config/routes.rb`

```ruby
Rails.application.routes.draw do
  mount Knock::Engine => "/knock"

  # your routes ...
end
```

Then include the `Knock::Authenticable` module in your `ApplicationController`

```ruby
class ApplicationController < ActionController::API
  include Knock::Authenticable
end
```

You can now protect your resources by adding the `authenticate` before_action
to your controllers like this:

```ruby
class MyResourcesController < ApplicationController
  before_action :authenticate

  def index
    # etc...
  end

  # etc...
end
```

If no valid token is passed with the request, Knock will respond with:

```
head :unauthorized
```

If you just want to read the `current_user`, without actually authenticating, you can also do that:

```ruby
class CurrentUsersController < ApplicationController
  def show
    if current_user
      head :ok
    else
      head :not_found
    end
  end
end
```

### Authenticating from a web or mobile application:

Example request to get a token from your API:
```
POST /knock/auth_token
{"auth": {"email": "foo@bar.com", "password": "secret"}}
```

Example response from the API:
```
201 Created
{"jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9"}
```

To make an authenticated request to your API, you need to pass the token in the request header:
```
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9
GET /my_resources
```

**NB:** HTTPS should always be enabled when sending a password or token in your request.

### Authenticated tests

To authenticate within your tests:

1. Create a valid token
2. Pass it in your request

e.g.

```ruby
class MyResourcesControllerTest < ActionController::TestCase
  def authenticate
    token = Knock::AuthToken.new(payload: { sub: users(:one).id }).token
    request.env['HTTP_AUTHORIZATION'] = "Bearer #{token}"
  end

  setup do
    authenticate
  end

  it 'responds successfully' do
    get :index
    assert_response :success
  end
end
```

#### Without ActiveRecord

If no ActiveRecord is used, then you will need to specify what Exception will be used when the user is not found with the given credentials.

```ruby
Knock.setup do |config|

  # Exception Class
  # ---------------
  #
  # Configure the Exception to be used (raised and rescued) for User Not Found.
  # note: change this if ActiveRecord is not being used.
  #
  # Default:
  config.not_found_exception_class_name = 'MyCustomException'
end
```

### Algorithms

The JWT spec supports different kind of cryptographic signing algorithms.
You can set `token_signature_algorithm` to use the one you want in the
initializer or do nothing and use the default one (HS256).

You can specify any of the algorithms supported by the
[jwt](https://github.com/jwt/ruby-jwt) gem.

If the algorithm you use requires a public key, you also need to set
`token_public_key` in the initializer.

## CORS

To enable cross-origin resource sharing, check out the [rack-cors](https://github.com/cyu/rack-cors) gem.

## Related links

- [10 things you should know about tokens](https://auth0.com/blog/2014/01/27/ten-things-you-should-know-about-tokens-and-cookies/)

## Contributing

1. Fork it ( https://github.com/nsarno/knock/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

MIT
