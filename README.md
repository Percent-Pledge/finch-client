# Finch universal HRIS Ruby client

Unofficial client library for working with the [Finch API](https://developer.tryfinch.com/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'finch-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install finch-client

## Setup

You'll need a [Finch developer account](https://developer.tryfinch.com/docs/reference/ZG9jOjI4NjYxNDQ4-registration) which will give you a client ID and client secret. Once this gem has been installed and you have the required credentials, you must place Finch configuration early in your app's boot process (eg: a Rails initializer):

```ruby
Finch::Client.configure do |config|
  config.client_id = '...'
  config.client_secret = '...'
  # Set this to `false` in production and `true` in any testing environment
  config.sandbox = false
  # Optional: set a logger. Defaults to $stdout
  config.logger = Logger.new(...)
end
```

## Usage

### Obtaining an access token

This is a mandatory first step toward interacting with the Finch API. The access token handshake informs the user of the permissions being requested and requires their consent to proceed, similar to any OAuth-like flow. You'll need to know your [redirect URI](https://developer.tryfinch.com/docs/reference/ZG9jOjMxOTg1NTI2-redirect-ur-is), [permissions](https://developer.tryfinch.com/docs/reference/ZG9jOjMxOTg1NTI3-permissions), and any [additional configuration](https://developer.tryfinch.com/docs/reference/ZG9jOjMyMDI2ODg3-your-application-redirects-to-connect#open-connect) you may need.

This gem includes a helper to generate the Finch authorization URL that you need the user to visit:

```ruby
redirect_uri = 'https://example.com'
permissions = 'company directory'
optional_params = { state: 'abc' }

Finch::Client::Connect.authorization_uri(redirect_uri, permissions, optional_params)
```

Once the user has authorized, they'll be redirected to your `redirect_uri` with a `code` query parameter. The final step in the authorization flow is to exchange this `code` with an access token:

```ruby
redirect_uri = 'https://example.com'
code = params[:code]

Finch::Client::Connect.request_access_token(redirect_uri, code)
```

Once you've received the access token, you can store it for future API calls on behalf of that user. Keep in mind that you may need to handle [re-authentication](https://developer.tryfinch.com/docs/reference/ZG9jOjMxOTg1NTI0-re-authentication).

### Creating a Finch API Client

Now that you have an access token you're able to configure a Finch client:

```ruby
finch_client = Finch::Client::API.new(access_token)
```

Keep in mind that this client instance is scoped only to the provided access token. You'll need to create a new client if you want to work with a different access token.

From here, you're set to use any of the Finch APIs listed below! All objects returned from API calls respond to `.headers` if you need to access the raw Finch headers.

### Organization APIs

**Company** ([API Documentation](https://developer.tryfinch.com/docs/reference/b3A6MTcxMzYwODg-company))

```ruby
finch_client.company
```

**Directory** ([API Documentation](https://developer.tryfinch.com/docs/reference/b3A6MTcxMzYwODk-directory))

```ruby
# Fetches all individuals
finch_client.directory

# Per the docs you can optionally specify a limit and offset
finch_client.directory({ limit: 5, offset: 1 })
```

**Individual** ([API Documentation](https://developer.tryfinch.com/docs/reference/b3A6MTcxMzYwOTA-individual))

```ruby
# Also accepts an array of hashes - see API docs for details
individual_params = { individual_id: '...' }

finch_client.individual(individual_params)
```

**Employment** ([API Documentation](https://developer.tryfinch.com/docs/reference/b3A6MTcxMzYwOTE-employment))

```ruby
# Also accepts an array of hashes - see API docs for details
individual_params = { individual_id: '...' }

finch_client.employment(individual_params)
```

### Payroll APIs

**Payment** ([API Documentation](https://developer.tryfinch.com/docs/reference/b3A6MTcxMzYwOTI-payment))

```ruby
# Fetches all payment data
finch_client.payment

# Per the docs you can optionally specify a start_date and end_date
finch_client.payment({ start_date: '2021-01-01', end_date: '2021-02-01' })
```

**Pay Statement** ([API Documentation](https://developer.tryfinch.com/docs/reference/b3A6MTcxMzYwOTM-pay-statement))

```ruby
# Also accepts an array of hashes - see API docs for details
pay_statement_requests = { payment_id: '...' }

finch_client.pay_statement(pay_statement_requests)
```

### Benefits APIs

**Get All Benefits** ([API Documentation](https://developer.tryfinch.com/docs/reference/b3A6MTg4Mzc2MTg-get-all-benefits))

```ruby
finch_client.benefits
```

**Create Benefit** ([API Documentation](https://developer.tryfinch.com/docs/reference/b3A6MTg4Mzc2MTk-create-benefit))

```ruby
# See API docs for details
benefit_data = {}

finch_client.create_benefit(benefit_data)
```

**Get Benefits Metadata** ([API Documentation](https://developer.tryfinch.com/docs/reference/b3A6MTg4Mzc2MjA-get-benefits-metadata))

```ruby
finch_client.benefits_metadata
```

**Get Benefit** ([API Documentation](https://developer.tryfinch.com/docs/reference/b3A6MjE4NDU0NTE-get-benefit))

```ruby
benefit_id = '...'

finch_client.benefit(benefit_id)
```

**Update Benefit** ([API Documentation](https://developer.tryfinch.com/docs/reference/b3A6MjE4NDU0NTI-update-benefit))

```ruby
benefit_id = '...'
# See API docs for details
benefit_data = {}

finch_client.update_benefit(benefit_id, benefit_data)
```

**Get Enrolled Individuals** ([API Documentation](https://developer.tryfinch.com/docs/reference/b3A6MjE4NDU0NTM-get-enrolled-individuals))

```ruby
benefit_id = '...'

finch_client.benefit_enrolled_individuals(benefit_id)
```

**Get Benefits for Individual** ([API Documentation](https://developer.tryfinch.com/docs/reference/b3A6MjE4NDU0NTQ-get-benefits-for-individuals))

```ruby
benefit_id = '...'
# Also accepts an array of strings - see API docs for details
individual_id = '...'

finch_client.benefits_for_individual(benefit_id, individual_id)
```

**Enroll Individuals in Benefits** ([API Documentation](https://developer.tryfinch.com/docs/reference/b3A6MjE4NDU0NTU-enroll-individuals-in-benefits))

```ruby
benefit_id = '...'
# See API docs for details
enrollment_data = {}

finch_client.enroll_individual_in_benefits(benefit_id, enrollment_data)
```

**Unenroll Individuals from Benefits** ([API Documentation](https://developer.tryfinch.com/docs/reference/b3A6MjE4NDU0NTY-unenroll-individuals-from-benefits))

```ruby
benefit_id = '...'
# Also accepts an array of strings - see API docs for details
individual_id = '...'

finch_client.unenroll_individual_from_benefits(benefit_id, individual_id)
```

### Management APIs

**Introspect** ([API Documentation](https://developer.tryfinch.com/docs/reference/b3A6MTc3MTk2Njk-introspect))

```ruby
finch_client.introspect
```

**Providers** ([API Documentation](https://developer.tryfinch.com/docs/reference/b3A6MTc3MTk2Njg-providers))

```ruby
finch_client.providers
```

**Disconnect** ([API Documentation](https://developer.tryfinch.com/docs/reference/b3A6MTc3MTk2NzA-disconnect))

```ruby
finch_client.disconnect
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

If you're using Docker, start the container with `docker compose up`, optionally passing the `-d` flag to start it in the background. From there, open a shell in the container with `docker compose exec gem bash` and run your `rake spec` or `bin/console` commands.

Finally, Rubocop is included for linting. Run `rubocop` to check for any style violations.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Percent-Pledge/finch-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Finch::Client project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/finch-client/blob/master/CODE_OF_CONDUCT.md).
