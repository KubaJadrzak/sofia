# typed: strict
# frozen_string_literal: true

module Sofia
  module Types
    class Adapter

      #: singleton(Sofia::Adapter::Base)
      attr_reader :klass

      #: (?untyped adapter) -> void
      def initialize(adapter = :net_http)
        name, klass = validate_and_set(adapter || :net_http)
        @name  = T.let(name, Symbol)
        @klass = T.let(klass, T.class_of(Sofia::Adapter::Base))
      end

      #: -> Symbol
      def to_sym
        @name
      end

      private

      #: (untyped) -> [Symbol, singleton(Sofia::Adapter::Base)]
      def validate_and_set(adapter)
        case adapter&.to_sym
        when :net_http
          [:net_http, Sofia::Adapter::NetHTTP]
        else
          Kernel.raise Sofia::Error::ArgumentError, "unknown adapter #{adapter}"
        end

      rescue NoMethodError
        Kernel.raise Sofia::Error::ArgumentError, "unknown adapter #{adapter}"
      end
    end
  end
end
