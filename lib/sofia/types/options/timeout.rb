# typed: strict
# frozen_string_literal: true

module Sofia
  module Types
    module Options
      module Timeout; end
    end
  end
end

require_relative 'timeout/base'
require_relative 'timeout/read'
require_relative 'timeout/write'
require_relative 'timeout/connection'
