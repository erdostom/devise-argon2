# Changelog

## Unreleased

## [2.0.3] - 2025-03-23

### Fixed
- Fix bug where users would not be migrated from v1 when setting a password manually. (#21)

## [2.0.2] - 2024-09-30

### Changed
- When migrating users from v1 to v2, the `encrypted_password` update will no longer trigger callbacks (ie send email to users)

### Added
- Tests for newer dependency versions

## [2.0.1] - 2023-10-18

### Added
- Add Argon2 and devise to the test suite
- Add @moritzhoeppner as an author

### Fixed
- Fix work factors implementation

## [2.0.0] - 2023-10-16

### Added
- Expose Argon2 options for configuring hashing work factors
- Add support for migration v1 hashes
- Add support for migrating bcrypt hashes
- Add tests for Mongoid
- Add Changelog :)

### Changed
- Change salting / peppering mechanism
- Change CI from Travis to GitHub Actions

### Removed
- Remove `devise-encryptable` dependency
- Remove superflous dependency on devise `password_salt` column

Thank you to @moritzhoeppner for the significant contributions to this release!

