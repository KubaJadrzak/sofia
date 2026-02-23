# Sofia

This is a personal project created for self-learning purposes. The goal is to create a simple HTTP client abstraction layer, similar to `Faraday`. At the current moment `Sofia` supports only `NetHTTP` as adapter, and only with `Content-Type: JSON` and default configuration. While basic, at the current moment `Sofia` is implement into my other project [Shopik](https://github.com/KubaJadrzak/Shopik) and allows to perform HTTP requests correctly. I will add more functionality with time. The goal is to ultimately create my own adapter as well.

# How it works

In order to perform a request with `Sofia` you need to initialize an instance of `client` class by providing `base_url` and `adapter`. At the current moment the only support adapter is `NetHTTP` and it will be used by default.
```
 @client = Sofia.new(base_url: base_url, adapter: adapter)
```

You can perform a request via method `send` on the instance of `client` class. You need to provide http request type (for now only `get`, `post`, `put`, `patch`, `delete` are supported) as method argument as well as block of code with configuration, for example: 
```
    response = @client.send(method) do |req|
      req.path = path
      req.headers['Accept'] = 'application/json'
      req.headers['Authorization'] = "Basic #{encoded_credentials}"
      req.body = body if body
    end
```
It is a good practice to rescue errors which can be thrown by `Sofia`. The response codes `400-499`  and `500-599` are not errors, instead you need to handle these on your own. This is an example of the entire flow that allows you to make a request based on my [Shopik](https://github.com/KubaJadrzak/Shopik) project where `Sofia` is implement as HTTP client abstraction layer:
```
class EspagoClient

  def initialize
    base_url = ENV.fetch('ESPAGO_BASE_URL')
    @user = Rails.application.credentials.dig(:espago, :app_id)
    @password = Rails.application.credentials.dig(:espago, :password)

    @client = Sofia.new(base_url: base_url)
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
