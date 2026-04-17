# typed: false
# frozen_string_literal: true

require 'test_helper'

module Sofia
  class RequestTest < Minitest::Test
    def base_url
      Sofia::Types::Client::BaseUrl.new('https://api.example.com')
    end

    # INITILIZATION

    def test_initializes_with_http_method_and_base_url
      request = Sofia::Request.new(
        http_method: :get,
        base_url:    base_url,
      )

      assert_equal :get, request.http_method
    end

    def test_initializes_with_empty_headers_params_and_body
      request = Sofia::Request.new(
        http_method: :get,
        base_url:    base_url,
      )

      assert_equal({ 'Content-Type' => 'application/json', 'Accept' => 'application/json' }, request.headers.to_h)
      assert_equal({}, request.body.to_h)
      assert_equal 'https://api.example.com/', request.url
    end

    # PATH

    def test_sets_path
      request = Sofia::Request.new(
        http_method: :get,
        base_url:    base_url,
      )

      request.path = '/users'

      assert_equal 'https://api.example.com/users', request.url
    end

    # PARAMS

    def test_sets_params_with_hash
      request = Sofia::Request.new(
        http_method: :get,
        base_url:    base_url,
      )

      request.path = '/users'
      request.params = { page: 1, per_page: 10 }

      url = request.url

      assert_includes url, 'page=1'
      assert_includes url, 'per_page=10'
    end

    def test_modifies_params_via_mutation
      request = Sofia::Request.new(
        http_method: :get,
        base_url:    base_url,
      )

      request.path = '/users'
      request.params['page'] = 2

      assert_equal 'https://api.example.com/users?page=2', request.url
    end

    def test_allows_multiple_params_via_mutation
      request = Sofia::Request.new(http_method: :get, base_url: base_url)

      request.path = '/users'

      request.params['page'] = 1
      request.params['per_page'] = 20
      request.params['sort'] = 'desc'

      url = request.url

      assert_includes url, 'page=1'
      assert_includes url, 'per_page=20'
      assert_includes url, 'sort=desc'
    end

    def test_allows_setting_params_via_hash_and_then_mutating
      request = Sofia::Request.new(http_method: :get, base_url: base_url)

      request.path = '/users'
      request.params = { page: 1 }
      request.params['filter'] = 'active'

      url = request.url

      assert_includes url, 'page=1'
      assert_includes url, 'filter=active'
    end

    # Headers

    def test_sets_headers_with_hash
      request = Sofia::Request.new(
        http_method: :post,
        base_url:    base_url,
      )

      request.headers = { 'X-Custom' => 'yes' }

      assert_equal(
        {
          'Content-Type' => 'application/json',
          'Accept'       => 'application/json',
          'X-Custom'     => 'yes',
        },
        request.headers.to_h,
      )
    end

    def test_modifies_headers_via_mutation
      request = Sofia::Request.new(
        http_method: :post,
        base_url:    base_url,
      )

      request.headers['Authorization'] = 'Bearer token'

      assert_equal(
        {
          'Content-Type'  => 'application/json',
          'Accept'        => 'application/json',
          'Authorization' => 'Bearer token',
        },
        request.headers.to_h,
      )
    end

    def test_allows_multiple_headers_via_mutation
      request = Sofia::Request.new(http_method: :get, base_url: base_url)

      request.headers['X-Request-Id'] = '123'
      request.headers['Authorization'] = 'Bearer token'

      assert_equal(
        {
          'Content-Type'  => 'application/json',
          'Accept'        => 'application/json',
          'X-Request-Id'  => '123',
          'Authorization' => 'Bearer token',
        },
        request.headers.to_h,
      )
    end

    def test_allows_setting_headers_via_hash_and_then_mutating
      request = Sofia::Request.new(http_method: :get, base_url: base_url)

      request.headers = { 'X-One' => '1' }
      request.headers['X-Two'] = '2'

      assert_equal(
        {
          'Content-Type' => 'application/json',
          'Accept'       => 'application/json',
          'X-One'        => '1',
          'X-Two'        => '2',
        },
        request.headers.to_h,
      )
    end

    def test_sets_body
      request = Sofia::Request.new(
        http_method: :post,
        base_url:    base_url,
      )

      request.body = { name: 'Sofia' }

      assert_equal({ 'name' => 'Sofia' }, request.body.to_h)
    end

    def test_allows_complex_body_structure
      request = Sofia::Request.new(http_method: :post, base_url: base_url)

      complex_body = {
        name:     'Sofia',
        age:      30,
        metadata: {
          role:   'admin',
          active: true,
        },
        tags:     %w[ruby api],
      }

      request.body = complex_body

      body = request.body.to_h

      assert_equal 'Sofia', body['name']
      assert_equal 30, body['age']
      assert_equal 'admin', body['metadata']['role']
      assert_equal true, body['metadata']['active']
      assert_equal %w[ruby api], body['tags']
    end

    def test_url_without_params
      request = Sofia::Request.new(
        http_method: :get,
        base_url:    base_url,
      )

      request.path = '/users'

      assert_equal 'https://api.example.com/users', request.url
    end

    def test_url_with_multiple_params
      request = Sofia::Request.new(
        http_method: :get,
        base_url:    base_url,
      )

      request.path = '/users'
      request.params = { page: 1, sort: 'desc' }

      url = request.url

      assert_includes url, 'page=1'
      assert_includes url, 'sort=desc'
      assert url.start_with?('https://api.example.com/users?')
    end

    def test_url_with_multiple_params_provided_via_mutation
      request = Sofia::Request.new(http_method: :get, base_url: base_url)

      request.path = '/search'
      request.params['q'] = 'ruby'
      request.params['page'] = 2
      request.params['per_page'] = 50

      url = request.url

      assert url.start_with?('https://api.example.com/search?')
      assert_includes url, 'q=ruby'
      assert_includes url, 'page=2'
      assert_includes url, 'per_page=50'
    end

  end
end
