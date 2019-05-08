[ ![Codeship Status for
financeit/marqeta](https://app.codeship.com/projects/c728ce40-d950-0136-6a02-660e8e347b40/status?branch=master)](https://app.codeship.com/projects/317336)

# Marqeta

An API client library for the [Marqeta API][marqeta_api].

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'marqeta', github: 'financeit/marqeta'
```

(The gem has not yet been released on rubygems.org)

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

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## See Also

* https://github.com/marqeta/marqeta-python (official Marqeta client for python)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/financeit/marqeta.

## About Financeit

[Financeit] is a fintech startup based in Toronto, Canada and we're [hiring].

[marqeta_api]: https://www.marqeta.com/api
[financeit]: https://www.financeit.io/
[hiring]: https://www.financeit.io/careers
