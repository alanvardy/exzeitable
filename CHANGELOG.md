# Changelog

## Unreleased

## v0.6.6 (2024-07-30)

- User can add additional classes to table elements

## v0.6.5 (2024-06-18)
- Add `:query_modifier` option to allow dynamic altering of queries
- Update Elixir and Erlang versions
- Update dependencies

## v0.6.4 (2024-03-03)
- Update Elixir and Erlang versions
- Update dependencies

## v0.6.3 (2023-09-17)
- Dependency updates and test fixes only

## v0.6.2 (2023-04-06)
- Re-release to fix versioning issue

## v0.6.1 (2023-04-06)
- Fix issue with adding action buttons to table
- Update to Phoenix 1.7

## v0.6.0 (2022-09-23)
- Make Exzeitable compatible with Phoenix LiveView 0.18

## v0.5.6 (2022-07-23)

- Make tooling dependencies test only
- Remove Phoenix Live Dashboard dependency

## v0.5.5 (2022-07-23)

- Bug fix for default formatter. Previously, it would attempt to_string on all values passing through which breaks `:safe` tuples.
- Support live routes
- Increase test coverage
- Fix CodeCov badge link
- Add BlitzCredoChecks
- Remove `:gettext` from `:compilers` in `mix.exs` as it is no longer required there
- Add additional dialyzer flags for OTP 25

## v0.5.4 (2022-04-30)

- Add `mix exzeitable.gen.migration` task for adding pg_trgm extension migration file
- General refactoring
- Added Params struct for representing the state
- Fix remaining `use Mix.Config`
- Cleanup stray files
- Add Doctor

## v0.5.3 (2022-03-30)

- Add formatter to field options
- Update Erlang to 24.2
- Update Elixir to 1.13.3
- Add a link to the Elixir Casts video in Readme
- Update Postgres to 14.2
- General refactoring

## v0.5.2 (2022-01-08)

- Update dependencies
- Update Credo and resolve Credo warnings

## v0.5.1 (2021-11-14)

- Re-add dependabot
- Update Elixir dependencies
- Add publish checklist
- Change `eex` templates to `heex`
- Add CodeCov

## v0.5.0 (2021-10-25)

- Update to Phoenix 1.6 and Phoenix LiveView 0.16
- Update Elixir and Erlang versions
- Rip out Webpack and fire it into the sun
- Capitalize word

## v0.4.6 (2021-08-21)

- Update CI configuration
- Tighten up typespecs
- Update docs
- Update Elixir dependencies
- Update JavaScript dependencies

## v0.4.5 (2021-04-04)

- Update dependencies
- Fix typos in moduledocs (Thank you `@clayscode`)

## v0.4.4 (2021-01-16)

- Update dependencies
- Switched out UglifyJS for TerserJS

## v0.4.3

- Remove Dependabot

## v0.4.2 (2020-08-31)

- Support searching across multiple columns (thank you `@greg-rychlewski`)
- Use regex for slightly improved search speed (thank you again `@greg-rychlewski`)
- Remove cypress-ci as its custom functionality is not being used on CI
- Update JavaScript assets
- Improve install instructions
- Provide docker-compose.yml for Postgres

## v0.4.1 (2020-07-10)

- Bugfix: Added custom text for "Actions" (was missed in the last release)
- Improved the test suite so that `mix check` runs `credo` before the other tests
- Improve the README
  
## v0.4.0 (2020-07-04)

- No breaking changes to API
- Feature: Added custom text functionality via the `:text` keyword
- Feature: Added ability to disable hide functionality
- Feature: Added ability to hide pagination
- Various dependency updates
- Refactored a bunch of things that were bugging me

## v0.3.3 (2020-06-19)

- I made no breaking changes to the API, only to dependency requirements.
- Feature: Add a refresh rate for re-querying database periodically
- Update Elixir and Javascript dependencies.
- Update Elixir to 1.10.3
- Update Erlang to 22.3.4
- Add MIT license
- Did some coarse-level refactoring around function locations

## v0.3.2 (2020-02-04)

- Update Elixir and Javascript dependencies.
- Add a route for tests.

## v0.3.1 (2020-02-04)

- Update to support Phoenix LiveView 0.6.0, removing the deprecated `mount/2` in favor of `mount/3`.

## v0.3.0 (2020-01-18)

- BREAKING CHANGES
- Update to support Phoenix LiveView 0.5.x (breaking compatibility with previous versions)
- Make sure to check the Phoenix LiveView [CHANGELOG](https://github.com/phoenixframework/phoenix_live_view/blob/master/CHANGELOG.md)
  
## v0.2.8 (2020-01-13)

- Use coalesce on all database columns to guard against NULL values

## v0.2.7 (2019-12-18)

- Dependency updates

## v0.2.6 (2019-12-07)

- Allow Phoenix LiveView 0.3 as well as 0.4

## v0.2.5 (2019-12-03)

- Added custom buttons, defined similarly to the custom fields
- Added a behaviour for render/1 in the user-defined table module
- Broke out `Pagination` and `ActionButton` modules from Exzeitable.HTML

## v0.2.4 (2019-10-31)

- Fix bug where order not removed when getting a count

## v0.2.3 (2019-10-21)

- Smoosh `assigns` and `socket.assigns` together and deduplicate
- Clear order_by before ordering query
- Correct documentation

## v0.2.2 (2019-10-20)

- Add support for passing assigns through to custom field functions
- Remove the actions column when no actions
- Added a nothing found message when no content
- Renamed CSS classes from .lt- to .exz-

## v0.2.1 (2019-10-18)

- Fixed a CSRF token error on delete actions

## v0.2.0 (2019-10-12)

- Rebuilt with Phoenix (originally was just a Mix project)
- Added dev environment
- Added acceptance tests with Cypress
- Added additional unit tests

## v0.1.2 (2019-10-11)

- Added ability to show and hide 'show buttons' for columns
- Disabled use of the enter key with the search box (created a CSRF error)
- Added specs
- Added documentation

## v0.1.1 (2019-10-09)

- Fix iOS touch issues
- Add inch_ex
- Minor documentation improvements

## v0.1.0 (2019-10-03)

- Initial release
