# typed: strict
# frozen_string_literal: true

module Sofia
  module Types
    module Options
      module Timeout
        class Base

          #: (untyped value) -> void
          def initialize(value)
            @value = validate_and_normalize(value) #: Float
          end

          #: -> Float
          def to_f
            @value
          end

          private

          #: (untyped) -> Float
          def validate_and_normalize(value)
            unless value.is_a?(Numeric) && value.to_f > 0
              raise Sofia::Error::ArgumentError, "timeout must be a positive number, got #{value.inspect}"
            end

            value.to_f
          end
        end
      end
    end
  end
end
