<!--
SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Public Domain Magic

A library of the conjuring arts in the public domain. The application catalogs
magic books (FRBR/WEMI), tracks their US copyright status and the countdown to
public domain, drives each title through a discovery-to-publication workflow,
and presents the result as a public, searchable library.

It is a Ruby on Rails app built in the 37signals / Omakase style with
Domain-Driven Design; see [`AGENTS.md`](AGENTS.md) for the engineering
standards and `doc/plans/` for the implementation history.

## Requirements

- Ruby (see [`.ruby-version`](.ruby-version))
- SQLite (development, test, and production all use SQLite)
- No Node.js/JavaScript build step — assets are served by Propshaft and
  Importmap.

## Getting started

```sh
bin/setup              # install gems and prepare the database
bin/rails db:seed      # load the real book corpus (idempotent; safe to re-run)
bin/rails server       # visit http://localhost:3000 — the library
```

`bin/setup` runs `bundle install` and `bin/rails db:prepare`. If you prefer to
do it by hand:

```sh
bundle install
bin/rails db:prepare
bin/rails db:seed
```

The first time you sign in, the app has no users: it walks you through a
first-run flow that creates the initial administrator.

## Seeding

The dev and production book corpus lives in [`db/seeds/`](db/seeds) as
fixture-shaped YAML and is loaded through the model layer (validations and
normalization run) by `Seeds::Loader`. `bin/rails db:seed` is idempotent —
each record is matched on a natural key, so re-running it only inserts titles
that are not present yet. Add a new title by adding rows to the YAML; no code
change is required.

## Running the tests

```sh
bin/rails test         # the Minitest suite
bundle exec rake       # the full pre-commit gate: lint, tests, and type check
```

`bundle exec rake` is authoritative: it runs RuboCop, the test suite, RDoc
coverage, REUSE license linting, and Steep type checking.

## License

Licensing follows the [REUSE](https://reuse.software) specification; see the
per-file SPDX headers and [`REUSE.toml`](REUSE.toml). Application source is
under the repository's `LICENSE`; documentation is CC-BY-SA-4.0.
