# typed: strict
# frozen_string_literal: true

require 'soren'

module Sofia
  module Adapter
    class Soren < Base
      class << self

        SOREN_CONNECTION_EXCEPTIONS = T.let(
          [
            ::Soren::Error::ConnectionError,
            ::Soren::Error::ConnectionRefused,
            ::Soren::Error::DNSFailure,
          ].freeze,
          T::Array[T.class_of(::Soren::Error::Base)],
        )

        SOREN_TIMEOUT_EXCEPTIONS = T.let(
          [
            ::Soren::Error::TimeoutError,
            ::Soren::Error::ReadTimeout,
          ].freeze,
          T::Array[T.class_of(::Soren::Error::Base)],
        )

        # @override
        #: (Sofia::Request request) -> Sofia::Response
        def call(request)
          uri        = parse_uri(request.url)
          connection = build_connection(uri, request)
          soren_req  = build_request(uri, request)
          response   = perform_request(connection, soren_req)
          adapt_response(response, request)
        end

        private

        #: (String url) -> URI::HTTP
        def parse_uri(url)
          uri = URI.parse(url)
          raise Sofia::Error::ArgumentError, 'only HTTP(S) URLs are supported' unless uri.is_a?(URI::HTTP)

          uri
        end

        #: (URI::HTTP uri, Sofia::Request request) -> ::Soren::Connection
        def build_connection(uri, request)
          ::Soren::Connection.new(
            host:    uri.host,
            port:    uri.port,
            scheme:  uri.scheme,
            options: {
              connect_timeout: request.options.connection_timeout.to_f,
              read_timeout:    request.options.read_timeout.to_f,
              write_timeout:   request.options.write_timeout.to_f,
            },
          )
        end

        #: (URI::HTTP uri, Sofia::Request request) -> ::Soren::Request
        def build_request(uri, request)
          body_hash = request.body.to_h
          body = body_hash.empty? || request.http_method == :get ? nil : JSON.dump(body_hash)

          ::Soren::Request.new(
            method:  request.http_method.to_s,
            target:  uri.request_uri,
            headers: request.headers.to_h,
            body:    body,
          )
        end

        #: (::Soren::Connection connection, ::Soren::Request soren_req) -> ::Soren::Response
        def perform_request(connection, soren_req)
          connection.send(soren_req)
        rescue ::Soren::Error::SSLError => e
          raise Sofia::Error::SSLError, e
        rescue *SOREN_CONNECTION_EXCEPTIONS => e
          raise Sofia::Error::ConnectionFailed, e
        rescue *SOREN_TIMEOUT_EXCEPTIONS => e
          raise Sofia::Error::TimeoutError, e
        rescue ::Soren::Error::ParseError => e
          raise Sofia::Error::ParserError, e
        end

        #: (::Soren::Response response, Sofia::Request request) -> Sofia::Response
        def adapt_response(response, request)
          Sofia::Response.new(
            status:   response.code,
            headers:  response.headers,
            raw_body: response.body,
            request:  request,
          )
        end

      end
    end
  end
end
