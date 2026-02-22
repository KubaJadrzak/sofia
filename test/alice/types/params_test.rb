# typed: false
# frozen_string_literal: true

require 'test_helper'
require 'uri'

class AliceTypesParamsTest < Minitest::Test

  def test_returns_empty_hash_when_no_argument_given
    params = Alice::Types::Params.new
    assert_equal({}, params.to_h)
    assert_equal '', params.to_s
  end

  def test_returns_empty_hash_when_nil_given
    params = Alice::Types::Params.new(nil)
    assert_equal({}, params.to_h)
    assert_equal '', params.to_s
  end

  def test_accepts_flat_hash
    input = { foo: 'bar', 'baz' => 123, qux: nil }
    params = Alice::Types::Params.new(input)

    expected = { 'foo' => 'bar', 'baz' => '123' }
    assert_equal expected, params.to_h
  end

  def test_reads_existing_param
    params = Alice::Types::Params.new('foo' => 'bar')
    assert_equal 'bar', params['foo']
    assert_equal 'bar', params[:foo]
  end

  def test_sets_param
    params = Alice::Types::Params.new
    params['foo'] = 123

    assert_equal '123', params['foo']
    assert_equal '123', params[:foo]
  end

  def test_to_h_returns_a_copy
    params = Alice::Types::Params.new('foo' => 'bar')
    copy = params.to_h
    copy['foo'] = 'modified'

    assert_equal 'bar', params['foo']
  end

  def test_to_s_encodes_params_as_www_form
    input = { foo: 'bar baz', num: 123 }
    params = Alice::Types::Params.new(input)

    expected = URI.encode_www_form('foo' => 'bar baz', 'num' => '123')
    assert_equal expected, params.to_s
  end

  def test_raises_when_params_is_not_a_hash
    error = assert_raises(Alice::Error::ArgumentError) do
      Alice::Types::Params.new('not a hash')
    end
    assert_match(/params must be a Hash/, error.message)
  end

  def test_raises_when_param_value_is_array
    input = { list: [1, 2] }
    error = assert_raises(Alice::Error::ArgumentError) do
      Alice::Types::Params.new(input)
    end
    assert_match(/invalid param value for list/, error.message)
  end

  def test_raises_when_param_value_is_hash
    input = { nested: { a: 1 } }
    error = assert_raises(Alice::Error::ArgumentError) do
      Alice::Types::Params.new(input)
    end
    assert_match(/invalid param value for nested/, error.message)
  end

  def test_skips_nil_values_in_initialization
    input = { foo: nil, bar: 'baz' }
    params = Alice::Types::Params.new(input)
    expected = { 'bar' => 'baz' }

    assert_equal expected, params.to_h
  end
end
