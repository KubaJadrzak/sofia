# frozen_string_literal: true

require 'test_helper'

class AliceTest < Minitest::Test
  def test_have_version_number
    refute_nil ::Alice::VERSION
  end

  def test_return_alice_client
    client = Alice.new(base_url: 'https://example.com', adapter: :net_http)

    assert_instance_of Alice::Client, client
    assert_equal 'https://example.com', client.base_url
    assert_equal :net_http, client.adapter
  end
end
