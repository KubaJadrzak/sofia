# typed: strict
# frozen_string_literal: true

module Sofia
  class Options

    #: Sofia::Types::Options::Timeout::Read
    attr_reader :read_timeout

    #: Sofia::Types::Options::Timeout::Write
    attr_reader :write_timeout

    #: Sofia::Types::Options::Timeout::Connection
    attr_reader :connection_timeout

    #: (?read_timeout: untyped, ?write_timeout: untyped, ?connection_timeout: untyped) -> void
    def initialize(read_timeout: nil, write_timeout: nil, connection_timeout: nil)
      @read_timeout = Sofia::Types::Options::Timeout::Read.new(
        read_timeout || Sofia::Defaults::Timeouts::READ_TIMEOUT,
      ) #: Sofia::Types::Options::Timeout::Read
      @write_timeout = Sofia::Types::Options::Timeout::Write.new(
        write_timeout || Sofia::Defaults::Timeouts::WRITE_TIMEOUT,
      ) #: Sofia::Types::Options::Timeout::Write
      @connection_timeout = Sofia::Types::Options::Timeout::Connection.new(
        connection_timeout || Sofia::Defaults::Timeouts::CONNECTION_TIMEOUT,
      ) #: Sofia::Types::Options::Timeout::Connection
    end
  end
end
