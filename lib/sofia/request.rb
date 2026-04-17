# typed: strict
# frozen_string_literal: true

module Sofia
  class Request

    #: Symbol
    attr_reader :http_method

    #: Sofia::Types::Client::Headers
    attr_reader :headers

    #: Sofia::Types::Client::Params
    attr_reader :params

    #: Sofia::Types::Client::Body
    attr_reader :body

    #: Sofia::Options
    attr_reader :options

    #: (http_method: Symbol, base_url: Sofia::Types::Client::BaseUrl, ?options: Sofia::Options) -> void
    def initialize(http_method:, base_url:, options: Sofia::Options.new)
      @http_method = http_method
      @base_url    = base_url
      @options     = options #: Sofia::Options
      @path        = Sofia::Types::Client::Path.new #: Sofia::Types::Client::Path
      @params      = Sofia::Types::Client::Params.new #: Sofia::Types::Client::Params
      @headers     = Sofia::Types::Client::Headers.new #: Sofia::Types::Client::Headers
      @body        = Sofia::Types::Client::Body.new #: Sofia::Types::Client::Body
    end

    #: (untyped path) -> void
    def path=(path)
      @path = Sofia::Types::Client::Path.new(path)
    end

    #: (untyped params) -> void
    def params=(params)
      @params = Sofia::Types::Client::Params.new(params)
    end

    #: (untyped headers) -> void
    def headers=(headers)
      @headers = Sofia::Types::Client::Headers.new(headers)
    end

    #: (untyped? body) -> void
    def body=(body)
      @body = Sofia::Types::Client::Body.new(body)
    end

    #: -> String
    def url
      qs = @params.to_s
      base = @base_url.to_s + @path.to_s
      qs.empty? ? base : "#{base}?#{qs}"
    end
  end
end
