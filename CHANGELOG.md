# UNRELEASED

### Added

- [internal] Added [guard](https://github.com/guard/guard) to run specs automatically upon file changes.

# v0.2.0 2019-01-08

### Added

- Added the `#fetch` method to `NxtConfig::Struct`.

### Changed

- Removed the `#[]` method from `NxtConfig::Struct` (BREAKING).
- Replaced `NxtConfig::load_and_constantize` with `NxtConfig::load` and changed the way configs are assigned to constants.

[Compare v0.1.0...v0.2.0](https://github.com/nxt-insurance/nxt_config/compare/v0.1.0...v0.2.0)

# v0.1.0 2019-01-04

Initial release.
