# typed: strict
# frozen_string_literal: true

module Sofia
  module Adapter
    class NetHTTP < Base
      class << self

        NET_HTTP_EXCEPTIONS = [
          IOError, Errno::ECONNREFUSED, Errno::ECONNRESET, SocketError,
        ].freeze

        TIMEOUT_EXCEPTIONS = [
          Net::OpenTimeout, Net::ReadTimeout, Errno::ETIMEDOUT,
        ].freeze

        # @override
        #: (Sofia::Request request) -> Sofia::Response
        def call(request)
          uri = parse_uri(request.url)
          http = configure_http(uri)
          net_req = build_request(uri, request)
          response = perform_request(http, net_req)
          adapt_response(response, request)
        end

        private

        #: (String url) -> URI::HTTP
        def parse_uri(url)
          uri = URI.parse(url)
          raise Sofia::Error::ArgumentError, 'only HTTP(S) URLs are supported' unless uri.is_a?(URI::HTTP)

          uri
        end

        #: (URI::HTTP uri) -> Net::HTTP
        def configure_http(uri)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = uri.scheme == 'https'
          http
        end

        #: (URI::HTTP uri, Sofia::Request request) -> Net::HTTPRequest
        def build_request(uri, request)
          klass = Net::HTTP.const_get(request.http_method.capitalize)
          net_req = klass.new(uri.request_uri)
          request.headers.each { |k, v| net_req[k] = v }
          body_hash = request.body.to_h
          net_req.body = JSON.dump(body_hash) unless body_hash.empty? || request.http_method == :get
          net_req
        end

        #: (Net::HTTPResponse response, Sofia::Request request) -> Sofia::Response
        def adapt_response(response, request)
          Sofia::Response.new(
            status:   response.code.to_i,
            headers:  response.each_header.to_h,
            raw_body: response.body,
            request:  request,
          )
        end

        #: (Net::HTTP http, Net::HTTPRequest net_req) -> Net::HTTPResponse
        def perform_request(http, net_req)
          http.request(net_req)
        rescue OpenSSL::SSL::SSLError => e
          raise Sofia::Error::SSLError, e
        rescue *NET_HTTP_EXCEPTIONS => e
          raise Sofia::Error::ConnectionFailed, e
        rescue *TIMEOUT_EXCEPTIONS => e
          raise Sofia::Error::TimeoutError, e
        end

      end
    end
  end
end
