# typed: false
# frozen_string_literal: true

require 'test_helper'

module Sofia
  module Types
    class AdapterTest < Minitest::Test
      def test_defaults_to_net_http_when_no_argument_given
        adapter = Sofia::Types::Adapter.new

        assert_equal :net_http, adapter.to_sym
        assert_equal Sofia::Adapter::NetHTTP, adapter.klass
      end

      def test_defaults_to_net_http_when_nil_is_given
        adapter = Sofia::Types::Adapter.new(nil)

        assert_equal :net_http, adapter.to_sym
        assert_equal Sofia::Adapter::NetHTTP, adapter.klass
      end

      def test_sets_net_http_when_symbol_is_given
        adapter = Sofia::Types::Adapter.new(:net_http)

        assert_equal :net_http, adapter.to_sym
        assert_equal Sofia::Adapter::NetHTTP, adapter.klass
      end

      def test_accepts_string_and_converts_to_symbol
        adapter = Sofia::Types::Adapter.new('net_http')

        assert_equal :net_http, adapter.to_sym
        assert_equal Sofia::Adapter::NetHTTP, adapter.klass
      end

      def test_raises_when_unknown_adapter_symbol_is_given
        error = assert_raises(Sofia::Error::ArgumentError) do
          Sofia::Types::Adapter.new(:unknown)
        end

        assert_match(/unknown adapter/, error.message)
      end

      def test_raises_when_unknown_adapter_string_is_given
        error = assert_raises(Sofia::Error::ArgumentError) do
          Sofia::Types::Adapter.new('foobar')
        end

        assert_match(/unknown adapter/, error.message)
      end

      def test_raises_when_object_without_to_sym_is_given
        obj = Object.new

        error = assert_raises(Sofia::Error::ArgumentError) do
          Sofia::Types::Adapter.new(obj)
        end

        assert_match(/unknown adapter/, error.message)
      end
    end
  end
end
