# Faraday::DiarioDeBordo

Middleware to save faraday request logs using the [diario_de_bordo](https://github.com/bidu/diario_de_bordo) gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'faraday-diario_de_bordo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install faraday-diario_de_bordo

## Usage

1. Create a connection with diario_de_bordo. Instructions in diario_de_bordo's [README](https://github.com/bidu/diario_de_bordo/README.md).
2. Add middleware to your Faraday connection:

```ruby
Faraday.new do |faraday|
  faraday.response :diario_de_bordo
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/faraday-diario_de_bordo.
