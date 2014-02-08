# Unofficial Ruby CloudStack client

[![Code Climate](https://codeclimate.com/github/promptworks/stacker_bee.png)](https://codeclimate.com/github/promptworks/stacker_bee)
[![Dependency Status](https://gemnasium.com/promptworks/stacker_bee.png)](https://gemnasium.com/promptworks/stacker_bee)
[![Build Status](https://travis-ci.org/promptworks/stacker_bee.png?branch=master)](https://travis-ci.org/promptworks/stacker_bee)
[![Gem Version](https://badge.fury.io/rb/stacker_bee.png)](http://badge.fury.io/rb/stacker_bee)

The unofficial CloudStack client for Ruby.

## Installation

You can install StackerBee with rubygems:

    $ gem install stacker_bee

If you are using Bundler simply add the following to your Gemfile:

```ruby
gem 'stacker_bee'
```

And execute:

    $ bundle install


## Basic Usage

```ruby
cloud_stack = StackerBee::Client.new(
  url:        'http://localhost:8080/client/api',
  api_key:    'MY_API_KEY',
  secret_key: 'MY_SECRET_KEY'
)

cloud_stack.list_virtual_machines state: 'Running'
# => [ { id: '48b91ab4...', displayName: '...', ... },
#      { id: '59c02bc5...', displayName: '...', ... },
#      ... ]

cloud_stack.create_volume name: 'MyVolume'
```

## Features

### Idomatic Ruby formatting for names

For example, you can use `list_virtual_machines` instead of `listVirtualMachines` and
`affinity_group_id` instead of `affinitygroupid` (if you want to).

For example:

```ruby
vm = cloud_stack.list_virtual_machines(affinity_group_id: id).first
puts vm[:iso_display_text]
```

### Handling 'map' parameters

For any endpoint requiring a map parameter, simply pass in a hash.

```ruby
cloud_stack.create_tags(tags: { type: 'community' }, resource_type: "Template", resource_ids: id )
```

This will yield a request with the following query string:

    ...&tags[0].key=type&tags[0].name=type&tags[0].value=community

### Configurable API Version

By default, StackerBee uses the CloudStack 4.2 API, but it doesn't have to.
Use a different API version by setting the `api_path` configuration option to the path of a JSON file containing the response from your CloudStack instance's `listApis` command.

```ruby
StackerBee::Client.api_path = '/path/to/your/listApis/response.json'
```

### CloudStack REPL

Usage:

    $ stacker_bee [OPTIONS]

Example:

    $ stacker_bee -u http://localhost:8080/client/api -a MY_API_KEY -s MY_SECRET_KEY
    StackerBee CloudStack REPL
    >> list_virtual_machines state: 'Running'
    => [{"id"=>"48b91ab4-dc23-4e24-bc6f-695d58c91087",
      "name"=>"MyVM",
      "displayname"=>"My VM",
      ...
    >>

## Configuration

Configuring a client:

```ruby
cloud_stack = StackerBee::Client.new(
  url:        'http://localhost:8080/client/api',
  api_key:    'API_KEY',
  secret_key: 'SECRET_KEY',
  logger:     Rails.logger
)
```

All configuration parameters set on the `StackerBee::Client` class are used as defaults for `StackerBee::Client` instances.

```ruby
StackerBee::Client.url    = 'http://localhost:8080/client/api'
StackerBee::Client.logger = Rails.logger

user_client = StackerBee::Client.new(
  api_key:    'USER_API_KEY',
  secret_key: 'USER_SECRET_KEY'
)

root_client = StackerBee::Client.new(
  api_key:    'ROOT_API_KEY',
  secret_key: 'ROOT_SECRET_KEY'
)
```

### URL

The URL of your CloudStack instance's URL.

```ruby
StackerBee::Client.url = 'http://localhost:8080/client/api'
```

Or:

```ruby
my_client = StackerBee::Client.new(
  url: 'http://localhost:8080/client/api'
)
```

### Keys

Your CloudStack credentials, i.e. API key and secret key.

```ruby
StackerBee::Client.api_key    = 'MY_API_KEY'
StackerBee::Client.secret_key = 'MY_SECRET_KEY'
```

Or:

```ruby
my_client = StackerBee::Client.new(
  api_key:    'MY_API_KEY',
  secret_key: 'MY_SECRET_KEY'
)
```

### Faraday Middleware

StackerBee is built on [Faraday](https://github.com/lostisland/faraday) and makes it easy for you to add Faraday middleware. Here's an example of adding your own middleware.

```ruby
StackerBee::Client.default_config = {
  middlewares: ->(faraday) do
    faraday.use Custom::LoggingMiddleware, Logger.new
    faraday.use Custom::CachingMiddleware, Rails.cache
  end
}
```

StackerBee itself puts some middlewares on Faraday. Any middlewares you add will be placed after these. If you want your middleware to come as the very first, you can use Faraday's builder like `faraday.builder.insert 0, MyMiddleware`.

### Logging

Logging is best handled with Faraday middleware.

#### GELF/Graylog2

If you're using the Graylog2 GELF format, you're in luck because StackerBee currently ships with a Faraday middleware for that. Here's an example of logging to Graylog2:

```ruby
logger = GELF::Notifier.new("localhost", 12201)

StackerBee::Client.default_config = {
  middlewares: ->(faraday) { faraday.use faraday.use StackerBee::GraylogFaradayMiddleware, logger }
}
```

#### Basic logging

To log to a file or STDOUT, Faraday has a built-in logger. You can use it like so:

```ruby
StackerBee::Client.default_config = {
  middlewares: ->(faraday) { faraday.response :logger }
}
```

### Bulk Configuration

The `StackerBee::Client` class can be configured with multiple options at once.

```ruby
StackerBee::Client.default_config = {
  url:        'http://localhost:8080/client/api',
  logger:     Rails.logger,
  api_key:    'API_KEY',
  secret_key: 'MY_SECRET_KEY'
}
```

## Contributing

### Testing

Running the tests:

    $ bundle exec rake

### Testing against CloudStack

To interact with a real CloudStack server, instead of the recorded responses:

    $ cp config.default.yml config.yml

And edit `config.yml`, specifying the URL and credentials for your CloudStack server. This file is used by the test suite if it exists, but is ignored by git.

### Coding Style

This project uses [Rubocop](https://github.com/bbatsov/rubocop) to enforce code style.

    $ bundle exec rubocop

### Releasing

To create a release, first bump the version in `lib/stacker_bee/version.rb`, and commit. Then, build the gem and release it to Rubygems with `rake release`:

    $ rake release
    stacker_bee 1.2.3 built to pkg/stacker_bee-1.2.3.gem.
    Tagged v1.2.3.
    Pushed git commits and tags.
    Pushed stacker_bee 1.2.3 to rubygems.org.

We use Bundler's gem tasks to manage releases. See the output of `rake -T` and [Bundler's Rubygems documentation](http://bundler.io/rubygems.html) for more information.

## Thanks to

- [Chip Childers](http://github.com/chipchilders) for a [reference implementation of a CloudStack client in Ruby](http://chipchilders.github.io/cloudstack_ruby_client/)

## License

StackerBee is released under the [MIT License](http://www.opensource.org/licenses/MIT).
