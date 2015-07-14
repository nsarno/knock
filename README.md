# knock [![Build Status](https://travis-ci.org/nsarno/knock.svg)](https://travis-ci.org/nsarno/knock) [![Test Coverage](https://codeclimate.com/github/nsarno/knock/badges/coverage.svg)](https://codeclimate.com/github/nsarno/knock/coverage) [![Code Climate](https://codeclimate.com/github/nsarno/knock/badges/gpa.svg)](https://codeclimate.com/github/nsarno/knock) [![security](https://hakiri.io/github/nsarno/knock/master.svg)](https://hakiri.io/github/nsarno/knock/master)

Seamless JWT authentication for Rails API

## Description

Knock is a [rails engine](http://guides.rubyonrails.org/engines.html). It provides an authentication solution for Rails API only application based on JSON Web Tokens ([JWT](http://jwt.io/)).

## Getting Started

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'knock'
```

And then execute:

    $ bundle install

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

## Contributing

1. Fork it ( https://github.com/[my-github-username]/mygem/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

MIT
