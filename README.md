# simsim [![Build Status](https://travis-ci.org/nsarno/simsim.svg)](https://travis-ci.org/nsarno/simsim) [![Test Coverage](https://codeclimate.com/github/nsarno/simsim/badges/coverage.svg)](https://codeclimate.com/github/nsarno/simsim/coverage) [![Code Climate](https://codeclimate.com/github/nsarno/simsim/badges/gpa.svg)](https://codeclimate.com/github/nsarno/simsim) [![security](https://hakiri.io/github/nsarno/simsim/master.svg)](https://hakiri.io/github/nsarno/simsim/master)

Seamless JWT authentication for Rails API

## Description

Simsim is a [rails engine](http://guides.rubyonrails.org/engines.html). It provides an authentication solution for Rails API only application based on JSON Web Tokens ([JWT](http://jwt.io/)).

## Getting Started

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'simsim'
```

And then execute:

    $ bundle install

### Usage

Mount the `Simsim::Engine` in your `config/routes.rb`

```ruby
Rails.application.routes.draw do
  mount Simsim::Engine => "/simsim"
  
  # your routes ...
end
```

Then include the `Simsim::Authenticable` module in your `ApplicationController`

```ruby
class ApplicationController < ActionController::API
  include Simsim::Authenticable
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
