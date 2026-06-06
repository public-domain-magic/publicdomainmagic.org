<!--
SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# AGENTS.md

## Introduction 

Project Name: PublicDomainMagic.org

Architecture: Ruby on Rails in the style of 37signals (Fizzy, Campfire, Writebook, Upright) with Domain-Driven Design (Eric Evans, Vaughn Vernon)

All breaking changes must be documented in the [Changelog](CHANGELOG.md)'s _Unreleased_ section.

## Ruby Standards

Every line of Ruby MUST be covered by tests that would stand up to mutation testing.

Define every class and method in `.rbs` files. Don't use `untyped`; be comprehensive and accurate. Do not include `initialize` in `.rbs` files; use `self.new` for constructors instead.

Every public Ruby class and method must be documented for humans in RDoc (not YARD). RDoc is written in `.rb` files, not `.rbs` files.

Every significant architectural and design decision must be documented for contributors in markdown files. Embedded mermaid is allowed.

## Rails Standards

The project follows a standard Rails layout. Use vanilla Rails conventions. Prefer built-ins over third-party gems. Write Rails in the style of 37signals (Fizzy, Campfire, Writebook, Upright).

The model layer must follow the ubiquitous language established in each bounded context. Each bounded context is a Rails engine.

## Workflow

When scripting, simple `sed` or shell one-liners are fine. When a one-off script grows to multiple lines of logic, prefer a temporary Rake task over a multi-line script in a string.

Documentation must be clear, concise, and useful to human and AI developers. Don't write .md files for something RDoc (Ruby) can generate.

Don't stage or commit unless explicitly instructed. Instead, suggest a commit message. When you do this, consider everything in `git diff HEAD`, because you are not the only one making changes.

Commit messages use [Conventional Commits](https://www.conventionalcommits.org/), plus an optional body wrapped at 72 characters. Commit bodies explain why this is the implementation, as opposed to other possible implementations. Skip the body entirely if it's rote, duplicates the diff, or is unhelpful. The commit message must be plain text.

The Changelog sollows [Semantic Versioning](https://semver.org/) and the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) specification. Only changes that affect application users (such as new features, UI changes, removals, and deprecations) belong in the changelog. Don't log, for example, automated tests, refactoring, or internal tooling. The Unreleased section is considered "since the last git tag". Therefore, if a change was done in one commit and undone in another (both since the last tag), the second committer removes its changelog entry. Never edit past version sections—those are frozen history.

Before considering a task complete and returning control to the user:

1. **Production Ready:** RBS types are complete and accurate (no `untyped`), errors are handled with good DX, documentation follows guidelines, high code quality (no "pre-existing debt" excuses).
2.  **Documentation Updated:** If public APIs or observable behavior changed, update relevant RDoc, RBS, and/or `README.md`.
3.  **Changelog Updated:** If public APIs or observable behavior changed, update [CHANGELOG.md](CHANGELOG.md)'s **Unreleased** section.
4.  **Commit Message Suggested:** Your final message to the user must include a suggested commit message block. Check `git log -n3` to see the current standard AI footer ("Generated with" and "Co-Authored-By") and include it in your suggested message.
