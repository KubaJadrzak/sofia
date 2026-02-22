# typed: false
# frozen_string_literal: true

require 'test_helper'

module Alice
  module Types
    class BodyTest < Minitest::Test
      def test_returns_empty_hash_when_no_argument_given
        body = Alice::Types::Body.new
        assert_equal({}, body.to_h)
      end

      def test_returns_empty_hash_when_nil_given
        body = Alice::Types::Body.new(nil)
        assert_equal({}, body.to_h)
      end

      def test_accepts_flat_hash
        input = { foo: 'bar', 'baz' => 123, qux: nil }
        body = Alice::Types::Body.new(input)

        expected = { 'foo' => 'bar', 'baz' => 123 } # nil removed
        assert_equal expected, body.to_h
      end

      def test_accepts_nested_hash
        input = { a: { b: 1, c: nil }, d: 'x' }
        body = Alice::Types::Body.new(input)

        expected = { 'a' => { 'b' => 1 }, 'd' => 'x' }
        assert_equal expected, body.to_h
      end

      def test_accepts_array_with_values_and_hashes
        input = {
          list: [
            1,
            { nested: 'ok', skip: nil },
            [2, nil, { deeper: 'yes' }],
          ],
        }
        body = Alice::Types::Body.new(input)

        expected = {
          'list' => [
            1,
            { 'nested' => 'ok' },
            [2, { 'deeper' => 'yes' }],
          ],
        }
        assert_equal expected, body.to_h
      end

      def test_removes_nil_values_from_array
        input = { arr: [nil, 1, nil, 2, nil] }
        body = Alice::Types::Body.new(input)

        expected = { 'arr' => [1, 2] }
        assert_equal expected, body.to_h
      end

      def test_returns_a_dup_of_internal_hash
        input = { foo: 'bar' }
        body = Alice::Types::Body.new(input)

        copy = body.to_h
        copy['foo'] = 'modified'

        assert_equal({ 'foo' => 'bar' }, body.to_h)
      end

      def test_raises_when_body_is_not_a_hash
        error = assert_raises(Alice::Error::ArgumentError) do
          Alice::Types::Body.new('not a hash')
        end
        assert_match(/body must be a Hash/, error.message)
      end

      def test_raises_when_body_is_number
        error = assert_raises(Alice::Error::ArgumentError) do
          Alice::Types::Body.new(123)
        end
        assert_match(/body must be a Hash/, error.message)
      end

      def test_raises_when_body_is_array
        error = assert_raises(Alice::Error::ArgumentError) do
          Alice::Types::Body.new([1, 2, 3])
        end
        assert_match(/body must be a Hash/, error.message)
      end
    end
  end
end
