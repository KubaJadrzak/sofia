# typed: false
# frozen_string_literal: true

require 'test_helper'

module Sofia
  module Types
    module Client
      class OptionsTest < Minitest::Test
        def test_returns_sofia_options_when_nil_is_given
          opts = Sofia::Types::Client::Options.new(nil)

          assert_instance_of Sofia::Options, opts.value
        end

        def test_returns_sofia_options_when_no_argument_is_given
          opts = Sofia::Types::Client::Options.new

          assert_instance_of Sofia::Options, opts.value
        end

        def test_returns_sofia_options_when_empty_hash_is_given
          opts = Sofia::Types::Client::Options.new({})

          assert_instance_of Sofia::Options, opts.value
        end

        def test_passes_hash_values_to_sofia_options
          opts = Sofia::Types::Client::Options.new(read_timeout: 5, write_timeout: 10, connection_timeout: 15)

          assert_equal 5.0, opts.value.read_timeout.to_f
          assert_equal 10.0, opts.value.write_timeout.to_f
          assert_equal 15.0, opts.value.connection_timeout.to_f
        end

        def test_raises_when_non_hash_is_given
          error = assert_raises(Sofia::Error::ArgumentError) do
            Sofia::Types::Client::Options.new('not a hash')
          end

          assert_match(/options must be a Hash/, error.message)
        end

        def test_raises_when_integer_is_given
          error = assert_raises(Sofia::Error::ArgumentError) do
            Sofia::Types::Client::Options.new(42)
          end

          assert_match(/options must be a Hash/, error.message)
        end
      end
    end
  end
end
