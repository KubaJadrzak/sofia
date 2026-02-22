# typed: false
# frozen_string_literal: true

require 'test_helper'

module Sofia
  module Types
    class SofiaTypesPathTest < Minitest::Test
      def test_defaults_to_slash_when_no_argument_given
        path = Sofia::Types::Path.new
        assert_equal '/', path.to_s
      end

      def test_returns_path_when_starts_with_slash
        input = '/my/path'
        path = Sofia::Types::Path.new(input)
        assert_equal input, path.to_s
      end

      def test_adds_leading_slash_when_missing
        input = 'my/path'
        path = Sofia::Types::Path.new(input)
        assert_equal '/my/path', path.to_s
      end

      def test_returns_single_slash_when_input_is_slash
        path = Sofia::Types::Path.new('/')
        assert_equal '/', path.to_s
      end

      def test_raises_when_path_is_not_a_string
        error = assert_raises(Sofia::Error::ArgumentError) do
          Sofia::Types::Path.new(123)
        end
        assert_match(/path must be a String/, error.message)
      end

      def test_raises_when_path_is_nil
        error = assert_raises(Sofia::Error::ArgumentError) do
          Sofia::Types::Path.new(nil)
        end
        assert_match(/path must be a String/, error.message)
      end
    end
  end
end
