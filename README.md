# Sofia

A simple HTTP client abstraction layer for Ruby, similar to `Faraday`. Sofia provides an abstraction layer so you can swap the underlying HTTP library without changing your application code. 

Sofia is currently implemented in my integration with Espago Payment System [Shopik](https://github.com/KubaJadrzak/Shopik) alongside my own HTTP client library [Soren](https://github.com/KubaJadrzak/soren), and everything seems to be working pretty good :P

# How it works

Initialize a client with a `base_url` and an optional `adapter` (defaults to `:net_http`):

```rb
@client = Sofia.new(base_url: base_url, adapter: adapter)
```

Call the desired HTTP method via `send` with a configuration block. The supported methods are `get`, `post`, `put`, `patch`, and `delete`:

```rb
response = @client.send(method) do |req|
  req.path = path
  req.headers['Accept'] = 'application/json'
  req.headers['Authorization'] = "Basic #{encoded_credentials}"
  req.body = body if body
end
```

Response codes in the `400–499` and `500–599` ranges are not raised as errors — inspect `response.status`, `response.client_error?`, or `response.server_error?` yourself.

| Error | Cause |
|---|---|
| `Sofia::Error::TimeoutError` | Read, write, or connection timeout |
| `Sofia::Error::ConnectionFailed` | DNS failure, refused connection, network error |
| `Sofia::Error::SSLError` | TLS handshake failure |
| `Sofia::Error::ParserError` | Response body is not valid JSON |

## Adapters

Sofia supports two adapter: `:net_http` as well as `:soren`. [Soren](https://github.com/KubaJadrzak/soren) is my own simple HTTP client library :P.

```rb
# Default — Net::HTTP
client = Sofia.new(base_url: 'https://api.example.com', adapter: :net_http)

# Soren
client = Sofia.new(base_url: 'https://api.example.com', adapter: :soren)
```

## Timeouts

Timeouts can be configured per client via the `options:` keyword:

```rb
client = Sofia.new(
  base_url: 'https://api.example.com',
  adapter: :net_http,
  options: {
    read_timeout:       60,   # seconds — default 30
    write_timeout:      30,   # seconds — default 30
    connection_timeout: 5,    # seconds — default 10
  },
)
```

Both adapters support all three timeout values.

## Example

This is an example of the entire flow from my [Shopik](https://github.com/KubaJadrzak/Shopik) project, where both `Sofia` HTTP client abstraction layer and `Soren` HTTP client library are implemented:

```rb
class EspagoClient

  def initialize
    base_url = ENV.fetch('ESPAGO_BASE_URL')
    @user = Rails.application.credentials.dig(:espago, :app_id)
    @password = Rails.application.credentials.dig(:espago, :password)

    @client = Sofia.new(base_url: base_url, adapter: :soren)
  end

  def send(path, body: nil, method: :get)
    response = @client.send(method) do |req|
      req.path = path
      req.headers['Accept'] = 'application/vnd.espago.v3+json'
      req.headers['Authorization'] = "Basic #{encoded_credentials}"
      req.body = body if body
    end

    ::Response.new(
      connected: true,
      status:    response.status,
      body:      response.body,
    )
  rescue Sofia::Error::TimeoutError
    ::Response.new(connected: false, body: { error: 'timeout' })
  rescue Sofia::Error::ConnectionFailed
    ::Response.new(connected: false, body: { error: 'connection_failed' })
  rescue Sofia::Error::SSLError
    ::Response.new(connected: false, body: { error: 'ssl_error' })
  rescue Sofia::Error::ParserError
    ::Response.new(connected: false, body: { error: 'parsing_error' })
  rescue URI::InvalidURIError, URI::BadURIError
    ::Response.new(connected: false, body: { error: 'invalid_uri' })
  rescue StandardError
    ::Response.new(connected: false, body: { error: 'unexpected_error' })
  end

  private

  #: -> String
  def encoded_credentials
    Base64.strict_encode64("#{@user}:#{@password}")
  end
end

```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sofia. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/sofia/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sofia project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/sofia/blob/master/CODE_OF_CONDUCT.md).
