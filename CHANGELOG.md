<!--
SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- User accounts with email-and-password sign in and sign out.
- First-run setup that creates the initial administrator when no account exists.
- Self-service password reset by email.
- Role-based access: administrator, librarian, researcher, and magician roles,
  granted by an administrator and recorded with who granted them and why.
- A public home page at the site root.
- Copyright determinations per work (or per edition), with statutory bases,
  a computed public-domain date, and a countdown for works still under term.
- Structured Rule 6 copyright investigations — author research with aliases
  and per-claim citations, republications, renewal searches and records,
  third-party claims, and findings — with the Project Gutenberg submission
  document generated as a report of that data.
- Project Gutenberg clearance requests tracked per digitized edition,
  validated against the copy.pglaf.org form limits, including page scans.

### Changed

- Catalog management now requires signing in.

### Fixed

### Removed
