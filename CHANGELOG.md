## [Unreleased]

## [0.1.5] - 2026-04-20

### Fixed

- Properly handle responses with empty '' body.

## [0.1.4] - 2026-04-20

### Added

- Soren gem updated to 0.1.5

## [0.1.3] - 2026-04-17

### Added

- Soren gem updated to 0.1.3

## [0.1.2] - 2026-04-17

### Added

- Soren adapter (`adapter: :soren`) — a second pluggable HTTP backend backed by the [soren](https://github.com/KubaJadrzak/soren) gem.

### Fixed

- `Sofia::Response#headers` now returns `Hash[String, Array[String]]` instead of `Hash[String, String]`, correctly preserving multi-value headers such as `Set-Cookie`.

## [0.1.0] - 2025-09-25

- Initial release
