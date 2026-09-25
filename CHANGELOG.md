# Changelog

## Unreleased

### Changed
- Default the development bundle to Rails 8.1, Devise 5.0, and Mongoid 9.1.
- Add Ruby 4.0 and released Devise 5.0 to CI while retaining older-version compatibility checks.
- Constrain CI dependencies to distinct minor series and use the latest patch releases.
- Test Mongoid 9.1 with Rails 8.1 and retain focused checks for Mongoid 8.1, Argon2 2.2, and Devise main.
- Update CI actions and remove the Docker Hub login requirement so fork pull requests can run tests.

### Added
- Database persistence checks for BCrypt/v1 hash migrations and password resets on both ORMs.
- Instructions for running the compatibility suite locally.

### Fixed
- Add missing password recovery fields to the Mongoid test models.
- Isolate Devise settings between examples and remove a duplicate test constant definition.

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
