# typed: strict
# frozen_string_literal: true

module Alice
  class Client

    HTTP_METHODS = %w[get post put patch delete].freeze

    #: (base_url: untyped, adapter: untyped) -> void
    def initialize(base_url:, adapter:)
      @base_url = Alice::Types::BaseUrl.new(base_url) #: Alice::Types::BaseUrl
      @adapter = Alice::Types::Adapter.new(adapter) #: Alice::Types::Adapter
    end

    #: -> String
    def base_url
      @base_url.to_s
    end

    #: -> Symbol
    def adapter
      @adapter.to_sym
    end

    HTTP_METHODS.each do |method|
      define_method(method) do |&block|
        request(method, &block)
      end
    end

    private

    #: (Symbol http_method) ?{ ( Request req ) -> untyped } -> Response
    def request(http_method, &block)
      raise Alice::Error::ArgumentError, 'configuration of the request must be provided via block' unless block

      req = Request.new(
        http_method: http_method,
        base_url:    @base_url,
      )

      block.call(req)

      @adapter.klass.call(req)
    end
  end
end
