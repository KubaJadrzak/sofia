# typed: false
# frozen_string_literal: true

require 'test_helper'

module Sofia
  module Adapter
    class SorenTest < Minitest::Test
      def setup
        @client = Sofia::Client.new(base_url: 'https://httpbin.org', adapter: :soren)
      end

      def test_performs_get_request_and_returns_response
        response = @client.get do |req|
          req.path = '/get'
          req.headers['Accept'] = 'application/json'
        end

        assert_equal 200, response.status
        assert_equal true, response.success?
        assert_equal 'https://httpbin.org/get', response.body['url']
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
      end

      def test_performs_put_request_and_returns_response
        response = @client.put do |req|
          req.path = '/put'
          req.body = { name: 'Updated Sofia' }
          req.headers['Content-Type'] = 'application/json'
        end

        assert_equal 200, response.status
        assert_equal true, response.success?
        assert_equal({ 'name' => 'Updated Sofia' }, response.body['json'])
      end

      def test_performs_patch_request_and_returns_response
        response = @client.patch do |req|
          req.path = '/patch'
          req.body = { name: 'Patched Sofia' }
          req.headers['Content-Type'] = 'application/json'
        end

        assert_equal 200, response.status
        assert_equal true, response.success?
        assert_equal({ 'name' => 'Patched Sofia' }, response.body['json'])
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
    end
  end
end
