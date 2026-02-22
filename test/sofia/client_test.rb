# frozen_string_literal: true

require 'test_helper'

module Sofia
  class ClientTest < Minitest::Test
    def setup
      @client = Sofia::Client.new(base_url: 'https://httpbin.org', adapter: nil)
    end

    def test_exposes_base_url
      assert_equal 'https://httpbin.org', @client.base_url
    end

    def test_exposes_adapter
      assert_equal :net_http, @client.adapter
    end

    def test_performs_get_request_and_returns_response
      response = @client.get do |req|
        req.path = '/get'
        req.headers['Accept'] = 'application/json'
      end

      assert_equal 200, response.status
      assert_equal true, response.success?
      assert_equal 'https://httpbin.org/get', response.body['url']
      assert_equal 'application/json', response.headers['content-type']
    end

    def test_performs_post_request_and_returns_response
      response = @client.post do |req|
        req.path = '/post'
        req.body = { name: 'Sofia' }
        req.headers['Content-Type'] = 'application/json'
      end

      assert_equal 200, response.status
      assert_equal true, response.success?
      assert_equal({ 'name' => 'Sofia' }, response.body['json'])
      assert_equal 'application/json', response.headers['content-type']
    end

    def test_performs_put_request_and_returns_response
      response = @client.put do |req|
        req.path = '/put'
        req.body = { name: 'Updated Sofia' }
        req.headers['Content-Type'] = 'application/json'
      end

      assert_equal 200, response.status
      assert_equal true, response.success?
      assert_equal({ 'name' => 'Updated Sofia' }, response.body.to_h['json'])
    end

    def test_performs_patch_request_and_returns_response
      response = @client.patch do |req|
        req.path = '/patch'
        req.body = { name: 'Patched Sofia' }
        req.headers['Content-Type'] = 'application/json'
      end

      assert_equal 200, response.status
      assert_equal true, response.success?
      assert_equal({ 'name' => 'Patched Sofia' }, response.body.to_h['json'])
    end

    def test_performs_delete_request_and_returns_response
      response = @client.delete do |req|
        req.path = '/delete'
        req.headers['Accept'] = 'application/json'
      end

      assert_equal 200, response.status
      assert_equal true, response.success?
      assert_equal 'https://httpbin.org/delete', response.body['url']
    end

    def test_raise_argument_error_if_missing_configuration
      error = assert_raises(Sofia::Error::ArgumentError) do
        @client.get
      end

      assert_equal 'configuration of the request must be provided via block', error.message
    end
  end
end
