# Minwise

Fast locality sensitive hashes using the minhash algorithm.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add minwise

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install minwise

## Usage

Generate the minhash of a string:

```ruby
Minwise::Minhash.digest("Chunky bacon")
# => [437974493, 147728091, 1185236492, ...]
```

Generate a minhash with options:

```ruby
Minwise::Minhash.digest("Chunky bacon", shingle_size: 9, hash_size: 500, seed: 42)
# => [203094719, 599941115, 1256960069, ...]
```

You can also generate a minhash of a bare set of integers:

```ruby
Minwise::Minhash.digest([1, 2, 3])
# => [1005141192, 713750329, 346603495, ...]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sbscully/minwise.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
