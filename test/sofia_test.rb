# frozen_string_literal: true

require 'test_helper'

class SofiaTest < Minitest::Test
  def test_have_version_number
    refute_nil ::Sofia::VERSION
  end

  def test_return_sofia_client
    client = Sofia.new(base_url: 'https://example.com', adapter: :net_http)

    assert_instance_of Sofia::Client, client
    assert_equal 'https://example.com', client.base_url
    assert_equal :net_http, client.adapter
  end
end
