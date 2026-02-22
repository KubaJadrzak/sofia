# typed: strict
# frozen_string_literal: true

module Sofia
  class Request

    #: Symbol
    attr_reader :http_method

    #: Sofia::Types::Headers
    attr_reader :headers

    #: Sofia::Types::Params
    attr_reader :params

    #: Sofia::Types::Body
    attr_reader :body

    #: (http_method: Symbol, base_url: Sofia::Types::BaseUrl) -> void
    def initialize(http_method:, base_url:)
      @http_method = http_method
      @base_url = base_url
      @path     = Sofia::Types::Path.new #: Sofia::Types::Path
      @params   = Sofia::Types::Params.new #: Sofia::Types::Params
      @headers  = Sofia::Types::Headers.new #: Sofia::Types::Headers
      @body     = Sofia::Types::Body.new #: Sofia::Types::Body
    end

    #: (untyped path) -> void
    def path=(path)
      @path = Sofia::Types::Path.new(path)
    end

    #: (untyped params) -> void
    def params=(params)
      @params = Sofia::Types::Params.new(params)
    end

    #: (untyped headers) -> void
    def headers=(headers)
      @headers = Sofia::Types::Headers.new(headers)
    end

    #: (untyped? body) -> void
    def body=(body)
      @body = Sofia::Types::Body.new(body)
    end

    #: -> String
    def url
      qs = @params.to_s
      base = @base_url.to_s + @path.to_s
      qs.empty? ? base : "#{base}?#{qs}"
    end
  end
end
