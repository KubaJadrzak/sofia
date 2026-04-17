# typed: strict
# frozen_string_literal: true

module Sofia
  module Types
    module Client
      class Options

        #: Sofia::Options
        attr_reader :value

        #: (?untyped options) -> void
        def initialize(options = nil)
          @value = build(options) #: Sofia::Options
        end

        private

        #: (untyped) -> Sofia::Options
        def build(options)
          case options
          when nil
            Sofia::Options.new
          when Hash
            Sofia::Options.new(**options)
          else
            Kernel.raise Sofia::Error::ArgumentError, "options must be a Hash, got #{options.class}"
          end
        end
      end
    end
  end
end
