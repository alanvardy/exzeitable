# Changelog

## v0.4.3 (2020-10-15)

* Removed dependabot due to general noise
* Updated dependencies

## v0.4.2 (2020-08-31)

* Support searching across multiple columns (thank you `@greg-rychlewski`)
* Use regex for slightly improved search speed (thank you again `@greg-rychlewski`)
* Remove cypress-ci as it's custom functionality is not being used on CI
* Update JavaScript assets
* Improve install instructions
* Provide docker-compose.yml for Postgres

## v0.4.1 (2020-07-10)

* Bugfix: Added custom text for "Actions" (was missed in last release)
* Improved test suite so that `mix check` runs `credo` before the other tests
* Improve the README
  
## v0.4.0 (2020-07-04)

* No breaking changes to API
* Feature: Added custom text functionality via the :text keyword
* Feature: Added ability disable hide functionality
* Feature: Added ability to hide pagination
* Various dependency updates
* Refactored a bunch of things that were bugging me

## v0.3.3 (2020-06-19)

* No breaking changes to API, only to dependency requirements.
* Feature: Add a refresh rate for requerying database periodically
* Update Elixir and Javascript dependencies.
* Update Elixir to 1.10.3
* Update Erlang to 22.3.4
* Add MIT licence
* Did some coarse level refactoring around function locations

## v0.3.2 (2020-02-04)

* Update Elixir and Javascript dependencies.
* Add a route for tests.

## v0.3.1 (2020-02-04)

* Update to support Phoenix LiveView 0.6.0, removing the deprecated `mount/2` in favour of `mount/3`.

## v0.3.0 (2020-01-18)

* BREAKING CHANGES
* Update to support Phoenix LiveView 0.5.x (breaking compatibility with previous versions)
* Make sure to check the Phoenix LiveView [CHANGELOG](https://github.com/phoenixframework/phoenix_live_view/blob/master/CHANGELOG.md)
  
## v0.2.8 (2020-01-13)

* Use coalesce on all database columns to guard against NULL values

## v0.2.7 (2019-12-18)

* Dependency updates

## v0.2.6 (2019-12-07)

* Allow Phoenix LiveView 0.3 as well as 0.4

## v0.2.5 (2019-12-03)

* Added custom buttons, defined similarly to the custom fields
* Added a behaviour for render/1 in the user defined table module
* Broke out a Pagination and ActionButton modules from Exzeitable.HTML

## v0.2.4 (2019-10-31)

* Fix bug where order not removed when getting a count

## v0.2.3 (2019-10-21)

* Smush assigns and socket.assigns together and deduplicate
* Clear order_by before ordering query
* Correct documentation

## v0.2.2 (2019-10-20)

* Add support for passing assigns through to custom field functions
* Remove actions column when no actions
* Added a nothing found message when no content
* Renamed CSS classes from .lt- to .exz-

## v0.2.1 (2019-10-18)

* Fixed a CSRF token error on delete actions

## v0.2.0 (2019-10-12)

* Rebuilt with Phoenix (originally was just a Mix project)
* Added dev environment
* Added acceptance tests with Cypress
* Added additional unit tests

## v0.1.2 (2019-10-11)

* Added ability to show and hide 'show buttons' for columns
* Disabled use of enter key with search box (created a CSRF error)
* Added specs
* Added documentation

## v0.1.1 (2019-10-09)

* Fix iOS touch issues
* Add inch_ex
* Minor documentation improvements


## v0.1.0 (2019-10-03)

* Initial release
