# typed: false
# frozen_string_literal: true

require 'test_helper'

module Sofia
  module Types
    module Client
      class HeadersTest < Minitest::Test
        def test_defaults_include_content_type_and_accept
          headers = Sofia::Types::Client::Headers.new

          expected = {
            'Content-Type' => 'application/json',
            'Accept'       => 'application/json',
          }

          assert_equal expected, headers.to_h
        end

        def test_merges_given_headers_with_defaults
          input = { 'X-Custom' => 'foo' }
          headers = Sofia::Types::Client::Headers.new(input)

          expected = {
            'Content-Type' => 'application/json',
            'Accept'       => 'application/json',
            'X-Custom'     => 'foo',
          }

          assert_equal expected, headers.to_h
        end

        def test_reads_existing_header
          headers = Sofia::Types::Client::Headers.new('X-Test' => 'value')
          assert_equal 'value', headers['X-Test']
          assert_equal 'value', headers[:'X-Test']
        end

        def test_sets_header
          headers = Sofia::Types::Client::Headers.new
          headers['X-Test'] = 'new-value'

          assert_equal 'new-value', headers['X-Test']
          assert_equal 'new-value', headers[:'X-Test']
        end

        def test_sets_header_value_converted_to_string
          headers = Sofia::Types::Client::Headers.new
          headers['X-Number'] = 123
          assert_equal '123', headers['X-Number']
        end

        def test_to_h_returns_a_copy
          headers = Sofia::Types::Client::Headers.new('X-Test' => 'foo')
          copy = headers.to_h
          copy['X-Test'] = 'bar'

          assert_equal 'foo', headers['X-Test']
        end

        def test_raises_when_headers_is_not_a_hash
          error = assert_raises(Sofia::Error::ArgumentError) do
            Sofia::Types::Client::Headers.new('not a hash')
          end
          assert_match(/headers must be a Hash/, error.message)
        end

        def test_raises_when_header_value_is_array
          input = { 'X-List' => [1, 2, 3] }
          error = assert_raises(Sofia::Error::ArgumentError) do
            Sofia::Types::Client::Headers.new(input)
          end
          assert_match(/invalid header value for X-List/, error.message)
        end

        def test_raises_when_header_value_is_hash
          input = { 'X-Map' => { a: 1 } }
          error = assert_raises(Sofia::Error::ArgumentError) do
            Sofia::Types::Client::Headers.new(input)
          end
          assert_match(/invalid header value for X-Map/, error.message)
        end

        def test_skips_nil_values_in_initialization
          input = { 'X-Null' => nil }
          headers = Sofia::Types::Client::Headers.new(input)
          assert_nil headers['X-Null']
        end
      end
    end
  end
end
