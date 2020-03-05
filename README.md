[![CircleCI](https://circleci.com/gh/nxt-insurance/nxt_config.svg?style=svg)](https://circleci.com/gh/nxt-insurance/nxt_config) [![Depfu](https://badges.depfu.com/badges/55572b7950c22f7f472a0adbf81b2ea4/count.svg)](https://depfu.com/github/nxt-insurance/nxt_config?project_id=10455)

# NxtConfig

This is a very simple tool to load YAML files into strict configuration structs, accessible through global constants. This is inspired by the famous [config](https://github.com/railsconfig/config) gem. The core features are:

* Load the content of a YAML file as a configuration object
* Strict attribute accessors
* Infinite amount of YAML files/configuration objects loadable (not just one)
* Configuration objects can be registered in a given namespace (especially useful when in use in ruby gems loaded by other applications) by calling `NxtConfig::load` in the namespace where the constant lives that its config struct is assigned to.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nxt_config'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install nxt_config

## Usage

You can create configuration object using `NxtConfig.load` from YAML files or directly from a hash. 
If you are in a rails application, you can do this in an initializer (e.g. `config/initializers/nxt_config.rb`).

```ruby
module MyRailsApp
  ExternalApiConfig = NxtConfig.load Rails.root.join('config', 'external_api.yml.erb')
end
```

Of course you can also load configuration structs everywhere else in the application. 
Depending on where you assign it to a constant, you can have many configuration structs available via constants namespaced all over your application, 
scoped to the context where you need them.

```ruby
# Use struct like method chaining to access nested data
MyRailsApp::ExternalApiConfig.http.headers.user_agent
# => "MyRailsApp 1.0.0"

# The struct methods are strict, so they raise an error if the attribute does not exist
MyRailsApp::ExternalApiConfig.non_existent_key
# => raises NoMethodError

# You can also use hash like #fetch calls with symbols (multiple ones, like with Hash#dig)
MyRailsApp::ExternalApiConfig.fetch(:http, :headers, :user_agent)
# => "MyRailsApp 1.0.0"

# You can also use hash like #fetch calls with strings (multiple ones, like with Hash#dig)
MyRailsApp::ExternalApiConfig.fetch("http", "headers", "user_agent")
# => "MyRailsApp 1.0.0"

MyRailsApp::ExternalApiConfig.fetch(:http, :oh_no, :user_agent, &Proc.new { 'Hy!' })
# => "Hy!"

# You can also pass a block to #fetch in case a key does not exist

# If you don't walk through the struct until its leaves, you will get a sub struct
MyRailsApp::ExternalApiConfig.http
# => #<NxtConfig::Struct:0x00007fe657467680 @hash={"headers"=>#<NxtConfig::Struct:0x00007fe657467518 @hash={"user_agent"=>"my cool app", "api_key"=>"secret123"}>}>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Run `bin/guard` for [guard](https://github.com/guard/guard) to start watching for file changes and running the corresponding specs accordingly.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nxt-insurance/nxt_config.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
