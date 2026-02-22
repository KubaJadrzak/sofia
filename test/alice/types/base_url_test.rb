# typed: false
# frozen_string_literal: true

require 'test_helper'
module Alice
  module Types
    class AliceTypesBaseUrlTest < Minitest::Test

      def test_returns_same_url_when_https
        url = 'https://example.com'
        base_url = Alice::Types::BaseUrl.new(url)

        assert_equal url, base_url.to_s
      end

      def test_returns_same_url_when_http
        url = 'http://example.com'
        base_url = Alice::Types::BaseUrl.new(url)

        assert_equal url, base_url.to_s
      end

      def test_strips_trailing_slash
        url = 'https://example.com/'
        base_url = Alice::Types::BaseUrl.new(url)

        assert_equal 'https://example.com', base_url.to_s
      end

      def test_adds_https_if_missing
        url = 'example.com'
        base_url = Alice::Types::BaseUrl.new(url)

        assert_equal 'https://example.com', base_url.to_s
      end

      def test_adds_https_if_missing_with_trailing_slash
        url = 'example.com/'
        base_url = Alice::Types::BaseUrl.new(url)

        assert_equal 'https://example.com', base_url.to_s
      end

      def test_raises_when_base_url_is_nil
        error = assert_raises(Alice::Error::ArgumentError) do
          Alice::Types::BaseUrl.new(nil)
        end
        assert_match(/base_url must be a non-empty String/, error.message)
      end

      def test_raises_when_base_url_is_empty_string
        error = assert_raises(Alice::Error::ArgumentError) do
          Alice::Types::BaseUrl.new('')
        end
        assert_match(/base_url must be a non-empty String/, error.message)
      end

      def test_raises_when_base_url_is_whitespace
        error = assert_raises(Alice::Error::ArgumentError) do
          Alice::Types::BaseUrl.new('   ')
        end
        assert_match(/base_url must be a non-empty String/, error.message)
      end

      def test_raises_when_base_url_is_not_a_string
        error = assert_raises(Alice::Error::ArgumentError) do
          Alice::Types::BaseUrl.new(123)
        end
        assert_match(/base_url must be a non-empty String/, error.message)
      end
    end
  end
end
