# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
bin/setup          # Install dependencies
rake test          # Run all tests
rake rubocop       # Lint with RuboCop
bundle exec srb tc # Sorbet type checking (run after every change)
bin/console        # IRB prompt with gem loaded
```

Run a single test file:
```bash
bundle exec ruby -Ilib:test test/sofia/client_test.rb
```

## Architecture

Sofia is a Ruby gem providing a lightweight HTTP client abstraction with pluggable adapters (similar to Faraday). Ruby >= 3.1 required. Uses Sorbet for static type checking (`# typed: strict` throughout).

**Request lifecycle:**
1. `Sofia.new(base_url:, adapter:)` → `Sofia::Client`
2. User calls `.get`, `.post`, etc. with a block that configures a `Request`
3. Client delegates to the adapter's `#call(request:)` method
4. Adapter returns a `Sofia::Response`

**Key classes:**
- `Sofia::Client` — stores base URL + adapter; exposes HTTP verb methods
- `Sofia::Request` — mutable DSL object; builds full URL from base + path + params
- `Sofia::Response` — immutable result; `#body` parses JSON, `#success?` checks 2xx
- `Sofia::Adapter::Base` — abstract; subclasses implement `#call(request:) → Response`
- `Sofia::Adapter::NetHTTP` — only current adapter; uses stdlib `Net::HTTP` with SSL auto-detection

**Type wrappers** (`lib/sofia/types/`) validate and normalize all inputs at construction time (fail-fast). `BaseUrl` auto-prepends `https://`; `Path` ensures leading `/`; `Headers` defaults to JSON content/accept types; `Body` strips nil values recursively.

**Error hierarchy** all inherit from `Sofia::Error::Base < StandardError`: `ArgumentError`, `ConnectionFailed`, `SSLError`, `TimeoutError`, `ParserError`.

## Adding a New Adapter

1. Create `lib/sofia/adapter/your_adapter.rb` subclassing `Sofia::Adapter::Base`
2. Implement `sig { override.params(request: Sofia::Request).returns(Sofia::Response) }` on `#call`
3. Register the adapter symbol in `lib/sofia/types/adapter.rb`

## Testing Notes

Tests mix real HTTP calls (against httpbin.org) in `test/sofia/client_test.rb` with unit tests for type wrappers. FactoryBot factories live in `test/factories/`.

## RuboCop

Config at `.rubocop.yml` uses `EnabledByDefault: true` (strict). Key limits: method 40 lines, class 200 lines, cyclomatic complexity 12. Trailing commas required in multiline literals.
