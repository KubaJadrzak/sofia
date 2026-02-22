# typed: strict
# frozen_string_literal: true

module Sofia
  class Client
    HTTP_METHODS = %w[get post put patch delete].freeze

    #: (base_url: untyped, adapter: untyped) -> void
    def initialize(base_url:, adapter:)
      @base_url = Sofia::Types::BaseUrl.new(base_url) #: Sofia::Types::BaseUrl
      @adapter = Sofia::Types::Adapter.new(adapter) #: Sofia::Types::Adapter
    end

    #: -> String
    def base_url
      @base_url.to_s
    end

    #: -> Symbol
    def adapter
      @adapter.to_sym
    end

    #: ?{ (Request req) -> untyped } -> Response
    def get(&) = request(:get, &)

    #: ?{ (Request req) -> untyped } -> Response
    def post(&) = request(:post, &)

    #: ?{ (Request req) -> untyped } -> Response
    def put(&) = request(:put, &)

    #: ?{ (Request req) -> untyped } -> Response
    def patch(&) = request(:patch, &)

    #: ?{ (Request req) -> untyped } -> Response
    def delete(&) = request(:delete, &)

    private

    #: (Symbol http_method) ?{ ( Request req ) -> untyped } -> Response
    def request(http_method, &block)
      raise Sofia::Error::ArgumentError, 'configuration of the request must be provided via block' unless block

      req = Request.new(
        http_method: http_method,
        base_url:    @base_url,
      )

      block.call(req)

      @adapter.klass.call(req)
    end
  end
end
