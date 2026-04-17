# typed: strict
# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require 'sorbet-runtime'
require 'byebug'

require_relative 'sofia/version'
require_relative 'sofia/error'
require_relative 'sofia/defaults'
require_relative 'sofia/types'
require_relative 'sofia/options'
require_relative 'sofia/request'
require_relative 'sofia/response'
require_relative 'sofia/adapter'
require_relative 'sofia/client'

module Sofia
  class << self
    #: (base_url: untyped, ?adapter: untyped, ?options: untyped) -> Sofia::Client
    def new(base_url:, adapter: nil, options: nil)
      Client.new(base_url: base_url, adapter: adapter, options: options)
    end
  end
end
