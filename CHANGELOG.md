# Changelog

## v0.2.8 (2019-01-13)

* Use coalesce on all database columns to guard against NULL values

## v0.2.7 (2019-12-18)

* Dependency updates

## v0.2.6 (2019-12-7)

* Allow Phoenix LiveView 0.3 as well as 0.4

## v0.2.5 (2019-12-3)

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
