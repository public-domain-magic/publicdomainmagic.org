---
name: rails-37signals-foundation
description: >
  Use when starting, scaffolding, or setting the architecture of a Rails app in the
  37signals / "Omakase" style, or when making the foundational stack decisions a new
  app must make once: database, background jobs, real-time adapter, multi-tenancy,
  caching, email, and deployment. Establishes the always-apply house style — near-empty
  ApplicationController, request-scoped Current, capability concerns as the unit of
  composition, importmap + Propshaft (no Node build), no service-object layer — and walks
  the decide-once forks. Trigger this even when the user doesn't say "37signals": also fires
  on "Omakase Rails," "vanilla Rails done right," "like Basecamp/HEY/Campfire/Writebook,"
  "no React, server-rendered Hotwire," or "majestic monolith." Do NOT use for per-feature
  implementation — defer to the models, auth, controllers-routing, frontend, and testing
  skills — or for non-Rails stacks.
---

# Building a Rails app the 37signals way — foundation

This skill sets the **bones and the stance**. It does not implement features. Per-layer
depth lives in sibling skills (see the skill map at the end).

## How to use the reference apps

You have read access to the four real apps under `refs/` (`fizzy`, `once-campfire`,
`writebook`, `upright`) — ground truth for any pattern here. Examples below use a neutral
`Post`/`Project`/`Comment` domain on purpose: the real apps model `Card`, `Room`, `Board`,
`Leaf`, `Probe`, so when you open the source, **lift the mechanism, translate the noun** —
never graft their domain onto yours.

## The stance (what the agent wouldn't otherwise assume)

A 37signals Rails app is a **server-rendered majestic monolith**. The defaults are
deliberate and often the inverse of common tutorials:

- **Secure, tenant-scoped, and HTML-first by default.** Behavior is opt-*out*, not opt-in.
- **Fat models, thin everything else.** Domain logic lives on models and plain Ruby objects.
  There is **no `app/services/` layer**. If you reach for a service object, write a model
  method or a PORO namespaced under its model instead.
- **The framework is enough.** Reach into Rails before reaching for a gem (no Devise, no
  Pundit, no RSpec, no FactoryBot, no Webpack/esbuild). Add a gem only when Rails genuinely
  can't do the job.
- **One database file, one box, one image** unless a real constraint says otherwise.

If the agent already builds Rails apps "the normal way," these are the corrections that make
it the 37signals way.

## Always-apply core (do this in every such app)

These are the shared house style. Apply them in every app you build. The reference apps vary
in the exact details — and upright, packaged as a mountable engine, skips some of this
entirely — so lift the *pattern*, not any one app's literal wording. Where an app diverges
in a way that matters, it's flagged.

### Near-empty ApplicationController

The base controller is a **manifest of `include`s** (auth + cross-cutting concerns), plus at
most `allow_browser versions: :modern`. No business logic ever lives here. (Detail →
controllers-routing skill; auth → auth skill.)

### Request context via `Current`, derived not just stored

```ruby
# app/models/current.rb
class Current < ActiveSupport::CurrentAttributes
  attribute :session, :user

  def session=(value)
    super
    self.user = value&.user      # assigning session cascades to user
  end
end
```

Set one attribute; let related ones fall out. Models read `Current.user` directly
(e.g. `belongs_to :author, default: -> { Current.user }`) instead of threading it through
controllers. `Current` resets between requests, so nothing leaks.

### Capability concerns are the unit of composition

A fat model is split into many small concerns, each owning **one capability end to end**
(its associations, scopes, callbacks, methods). They are namespaced **under the model**, in
a folder named after it — **not** in `app/models/concerns/`.

```ruby
# app/models/post.rb
class Post < ApplicationRecord
  include Publishable, Archivable, Commentable, Searchable
end

# app/models/post/publishable.rb  →  module Post::Publishable
```

`app/models/concerns/` is reserved for behavior genuinely shared across *unrelated* models.
The class reads as a table of contents. (Depth → models skill.)

### Framework monkey-patches live in `lib/rails_ext/`, loaded outside Zeitwerk

When you must reopen a framework or core class, quarantine it:

```ruby
# config/application.rb — add rails_ext to whatever's already in the ignore list
config.autoload_lib(ignore: %w[assets tasks rails_ext])

# config/initializers/extensions.rb — require every patch file once, at boot
Dir["#{Rails.root}/lib/rails_ext/*"].each { |path| require "rails_ext/#{File.basename(path)}" }
```

These files reopen classes Zeitwerk doesn't own and define multiple constants per file, so
they're `require`d explicitly, once, at boot — never autoloaded. (The exact `ignore:` contents
and order vary by app; the rule is just "add `rails_ext` to it." Mountable engines like upright
don't call `autoload_lib` at all — this is for standard apps.)

### Front end: importmap + Propshaft, zero build step

No `package.json`, `node_modules`, bundler, or SCSS. JS is pinned in `config/importmap.rb`
and served as raw ES modules; CSS is hand-written, served by Propshaft; Turbo + Stimulus
replace the SPA framework. Don't reach for esbuild/Vite/Tailwind-via-Node. (Depth → frontend skill.)

### RESTful-only, resource-per-concept

Controllers expose only the standard seven actions. When a verb doesn't map to CRUD, invent
a **resource** named for the noun rather than adding a custom action. (Depth →
controllers-routing skill.)

## Decide-once forks (the choices a new app must make)

These genuinely differ across the reference apps — they are project-setup decisions, not
house style. Make each one deliberately at the start. **Read
[`references/setup-decisions.md`](references/setup-decisions.md)** for the options, the
trade-offs, a recommended default, and the `refs/` pointer for each:

- **Database** — SQLite-in-production (default) vs. dual-adapter portability
- **Background jobs** — Solid Queue (default) vs. Resque/Redis
- **Real-time adapter** — solid_cable (default) vs. Redis
- **Multi-tenancy** — single-tenant (default) vs. subdomain vs. URL-path
- **Email** — full ActionMailer vs. none (Web Push / in-app links)
- **Deployment** — Kamal (default) vs. Procfile + Thruster supervisor

Default recommendation for a fresh single-product app: **SQLite + the Solid trifecta
(Queue/Cache/Cable) + single-tenant + Kamal**, adding email only if you must reach people
who aren't logged in. Justify any departure by a concrete constraint (scale, existing infra,
true multi-tenancy).

## What NOT to copy from the reference apps

Some patterns in the reference apps are bound to *their* product and will mislead a
general app. Do not lift these:

- **Packaging a line-of-business app as a mountable Rails engine** (upright). It exists
  because upright is deployed many times as a product; a normal app gains nothing and pays
  real friction.
- **Reverse-proxy controllers, shipped Prometheus rules, read-side POROs over an external
  TSDB** (upright). Monitoring-product specifics.
- **Connection-counted presence with TTL, STI room types, an in-memory `Sound` catalog**
  (campfire). Chat specifics.

**But beware over-pruning.** Several patterns that *look* app-specific are in fact broadly
transferable — lift them whenever your app has the matching need:

- **Mentions modeled as ActionText attachables** (not regex) — for any rich-text app with @mentions.
- **Domain verbs on the aggregate root** (e.g. a `publish`/`press`-style method instead of
  raw `create!`) — general modeling guidance.
- **`to_key` + a client-supplied id for optimistic-UI idempotency** — any optimistic UI.
- **API-key auth path for programmatic clients; IP-ban-before-auth** — common integration
  and abuse-mitigation needs.

When in doubt, ask: "is this tied to *their product*, or is it a *technique*?" Techniques transfer.

## Skill map

Hand off to the sibling skill for implementation depth:

- **models** — concerns, `Current`, POROs, `delegated_type`, enums, `signed_id`, search, callbacks
- **auth** — fail-closed `require_authentication` + opt-out macros, `has_secure_password` on a `User` + a `Session` model (never Devise), `signed_id` links, rate limiting, bots
- **controllers-routing** — thin actions, resource-per-concept, `scope module:`, `direct`/`resolve`, scope-through-`Current` authz, `params.expect`
- **frontend** — ERB (locals, `dom_id`, `content_for` regions, tiny `turbo_stream` templates, fragment caching), tag-building helpers, tiny Stimulus controllers, hand-written CSS, Turbo real-time
- **testing** — Minitest + fixtures, real-login helpers, mock only at the network boundary, sparse system tests, `parallelize`
