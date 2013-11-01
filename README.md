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

    gem 'stacker_bee'

And execute:

    $ bundle install

## Basic Usage

    my_client = StackerBee::Client.new({
      url:        'http://localhost:8080/client/api',
      api_key:    'MY_API_KEY',
      secret_key: 'MY_SECRET_KEY'
    })

    my_client.list_virtual_machines

    my_client.create_volume name: "MyVolume"

## Basic Configuration

All configuration parameters set on the Client class are used as defaults for Client instances.

### URL

Your CloudStack URL. E.g. http://localhost:8080/client/api

    StackerBee::Client.url = "http://localhost:8080/client/api"

Or:

    my_client = StackerBee::Client.new({
      url: 'http://localhost:8080/client/api'
    })

### Keys

Your CloudStack credentials, i.e. API key and secret key.

    StackerBee::Client.api_key    = "MY_API_KEY"
    StackerBee::Client.secret_key = "MY_SECRET_KEY"

Or:

    my_client = StackerBee::Client.new({
      api_key:    'MY_API_KEY',
      secret_key: 'MY_SECRET_KEY'
    })

### Logger

Your logger of choice.

    StackerBee::Client.logger = Rails.logger

Or:

    my_client = StackerBee::Client.new({
      logger: Rails.logger
    })

## Configurable API

    StackerBee::Client.api_path = "/path/to/your/listApis/response.json"

## CLI

Usage:

    $ stacker_bee [OPTIONS]

Examples:

    $ stacker_bee -u http://localhost:8080/client/api -a MY_API_KEY -s MY_SECRET_KEY
    StackerBee CloudStack REPL
    >> list_virtual_machines state: 'Running'
    => [{"id"=>"48b91ab4-dc23-4e24-bc6f-695d58c91087",
      "name"=>"MyVM",
      "displayname"=>"My VM",
      ...
    >>

## Contributing

Running the tests:

    $ rake

To interact with a real CloudStack server:

    $ cp config.default.yml config.yml

And edit `config.yml`, specifying the URL and credentials for your CloudStack server. This file is ignored by git.

## License

StackerBee is released under the [MIT License](http://www.opensource.org/licenses/MIT).
