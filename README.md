[ ![Codeship Status for
financeit/marqeta](https://app.codeship.com/projects/b9d56aa0-fec3-0135-5a6d-462e71abe528/status?branch=master)](https://app.codeship.com/projects/279548)

# Marqeta

An API client library for the [Marqeta API][marqeta_api].

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'marqeta'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install marqeta

## Usage

The following config attributes need to be set when using the gem:

```ruby
Marqeta.configure do |config|
  config.logger = <CUSTOM_LOGGER>
  config.username = <MARQETA API USERNAME>
  config.password = <MARQETA API PASSWORD>
  config.base_url = <MARQETA API BASE URL>
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/financeit/marqeta.

## About Financeit

[Financeit] is a fintech startup based in Toronto, Canada and we're [hiring].

[marqeta_api]: https://www.marqeta.com/api
[financeit]: https://www.financeit.io/
[hiring]: https://www.financeit.io/ca/en/careers
