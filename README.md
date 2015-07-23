# knock
[![Gem Version](https://badge.fury.io/rb/knock.svg)](http://badge.fury.io/rb/knock)
[![Build Status](https://travis-ci.org/nsarno/knock.svg)](https://travis-ci.org/nsarno/knock)
[![Test Coverage](https://codeclimate.com/github/nsarno/knock/badges/coverage.svg)](https://codeclimate.com/github/nsarno/knock/coverage)
[![Code Climate](https://codeclimate.com/github/nsarno/knock/badges/gpa.svg)](https://codeclimate.com/github/nsarno/knock)
[![Dependencies](https://img.shields.io/gemnasium/nsarno/knock.svg)](https://gemnasium.com/nsarno/knock)

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

We're using it in our own apps, and we'll keep improving it.

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

### Authenticating from a web or mobile application (HTTPS should be enabled):

To get a token from your API:

```
POST /knock/auth_token { email: 'foo@example.net', password: 'bar' }
```

To make an authenticated request to your API, you need to pass the token in the request header:

```
Authorization: Bearer TOKEN
GET /my_resources
```

### Authenticated tests

To authenticate within your tests:

1. Create a valid token
2. Pass it in your request

e.g.

```ruby
class MyResourcesControllerTest < ActionController::TestCase
  def authenticate
    token = Knock::AuthToken.new(payload: { sub: users(:one).id }).token
    request.env['HTTP_AUTHORIZATION'] = "bearer #{token}"
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

## CORS

To enable cross-origin resource sharing, check out the [rack-cors](https://github.com/cyu/rack-cors) gem.

## Related links

- [10 things you should know about tokens](https://auth0.com/blog/2014/01/27/ten-things-you-should-know-about-tokens-and-cookies/)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/mygem/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

MIT
