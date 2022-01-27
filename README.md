# Finch::Client

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/finch/client`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'finch-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install finch-client

## Usage

TODO: Write better usage instructions here

## Basic usage

Add the Finch configuration block early in your application (eg: a Rails initializer):

```ruby
Finch::Client.configure do |config|
  config.client_id = '...'
  config.client_secret = '...'
  config.sandbox = false
end
```

Next, you need the user to make a request to the Finch authorization endpoint:

```ruby
redirect_uri = 'https://example.com'
permissions = 'company directory'
optional_params = { state: 'abc' }

# This helper will generate the URL that the client needs to visit.
# Once complete, they'll be sent to `redirect_uri` with a `code` parameter - save that for the next step
authorization_endpoint = Finch::Client::Connect.authorization_uri(redirect_uri, permissions, optional_params)
```

Once the user has authenticated, you need to exchange their short-lived code for a longer-lived access token

```ruby
redirect_uri = 'https://example.com'
code = params[:code]
access_token = Finch::Client::Connect.request_access_token(redirect_uri, code)
```

From there, you can store the access token for future use. An example API request would look like this:

```ruby
finch_client = Finch::Client::API.new(access_token)

finch_client.company # Fetches a company's details
finch_client.directory # Fetches user directory for a company
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/finch-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Finch::Client project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/finch-client/blob/master/CODE_OF_CONDUCT.md).
