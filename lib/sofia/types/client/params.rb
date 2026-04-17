# typed: strict
# frozen_string_literal: true

module Sofia
  module Types
    module Client
      class Params
        extend T::Sig

        #: (?untyped params) -> void
        def initialize(params = {}) # rubocop:disable Style/OptionHash
          @params = validate_and_normalize(params || {}) #: Hash[String, String]
        end

        #: (untyped key) -> void
        def [](key)
          @params[key.to_s]
        end

        #: (untyped key, untyped value) -> void
        def []=(key, value)
          @params[key.to_s] = value.to_s
        end

        #: -> Hash[String, String]
        def to_h
          @params.dup
        end

        #: -> String
        def to_s
          URI.encode_www_form(@params)
        end

        private

        #: (untyped) -> Hash[String, String]
        def validate_and_normalize(headers)
          Kernel.raise Sofia::Error::ArgumentError, 'params must be a Hash' unless headers.is_a?(Hash)
          normalized = {}

          headers.each do |key, value|
            next if value.nil?

            if value.is_a?(Hash) || value.is_a?(Array)
              Kernel.raise Sofia::Error::ArgumentError, "invalid param value for #{key}"
            end

            normalized[key.to_s] = value.to_s
          end

          normalized
        end
      end
    end
  end
end
