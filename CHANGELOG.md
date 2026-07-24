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
- A site-wide header that shows who is signed in and offers a sign-out
  control; the home page greets a signed-in user instead of inviting them
  to sign in.
- First-run setup that creates the initial administrator when no account exists.
- Self-service password reset by email.
- Role-based access: administrator, librarian, researcher, and magician roles,
  granted by an administrator and recorded with who granted them and why.
- A public marketing site at the root — a home page plus About, Our Goals,
  Exposure, Accessibility, Contribute, and Newsletter pages — introducing the
  project, styled after Standard Ebooks with an inline logotype.
- A public library: browse the collection and search it by title, creator
  (including name variants), or topic, with a page for each book showing its
  creators, editions, subjects, copyright status and public-domain countdown,
  where to read it, and where to buy it. Protected titles remain discoverable;
  only their downloads honor the access gate.
- Copyright determinations per work (or per edition), with statutory bases,
  a computed public-domain date, and a countdown for works still under term.
- Structured Rule 6 copyright investigations — author research with aliases
  and per-claim citations, republications, renewal searches and records,
  third-party claims, and findings — with the Project Gutenberg submission
  document generated as a report of that data.
- Project Gutenberg clearance requests tracked per digitized edition,
  validated against the copy.pglaf.org form limits, including page scans.
- Workflow projects tracking each book's journey as a step ledger
  (discovery through publication and print editions), with per-step actor
  and date, links to our own production artifacts (the uploaded scan set,
  the book's text repository, the published ebook), and readiness checks
  that read the Copyright context. Where a book otherwise exists online is
  recorded as a catalog edition, not a workflow resource.
- Public book listings with a download access gate: public books are open to
  everyone, while protected books (whose methods working magicians still rely
  on) require the magician or librarian capability.
- Purchase links on listings for commerce and countdown affiliate hooks.
- Flat tags for classifying listings, optionally bridged to catalog subjects.
- Librarians can record a discovered book through one guided form (the
  Discovery workflow): the work, its authors, the copies found online (each
  an edition, with where to read it), and third-party records about it. Saving
  creates the catalog record, opens a copyright determination — computing the
  public-domain countdown when the first-publication year makes it certain —
  starts a workflow project, and publishes the book to the public library.
- Book pages now list where to read a title from its catalog editions (online
  resources) alongside the Public Domain Magic edition once published.

### Changed

- Catalog management now requires signing in.

### Fixed

### Removed
