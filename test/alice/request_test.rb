# frozen_string_literal: true

require 'test_helper'

module Alice
  class RequestTest < Minitest::Test
    def setup
      @req = Request.new(
        http_method: :post,
        base_url:    'https://example.com',
        path:        '/',
        headers:     {},
        body:        nil,
      )
    end

    def test_url_return_base_url_plus_path
      @req.path = '/foo'
      assert_equal 'https://example.com/foo', @req.url
    end
  end
end
