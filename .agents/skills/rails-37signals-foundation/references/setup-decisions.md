# Decide-once setup forks

Make each choice deliberately when scaffolding. Each section: the options, when to pick
which, the recommended default for a fresh single-product app, and where to read the real
thing. Translate the reference app's domain nouns to yours.

---

## Database (production)

**Options**
- **SQLite in production** *(default)* — one file under `storage/`, one box, backups are a
  directory copy. Tune for web concurrency in `config/database.yml`:
  `pool: <RAILS_MAX_THREADS>`, `timeout`, and crucially `default_transaction_mode: immediate`
  (acquires the write lock at `BEGIN`, avoiding the "database is locked" upgrade deadlock).
  Rails 8 enables WAL and the other PRAGMAs for you.
- **Dual-adapter portability (SQLite + MySQL/Trilogy)** — only if you ship the same code to a
  single-box install *and* a managed multi-tenant deployment. Costs two schema dumps and
  adapter-conditional migrations; do not take this on without that requirement.

**Default:** SQLite in production.

**Read:** `refs/writebook/config/database.yml`, `refs/once-campfire/config/database.yml`
(SQLite). Dual-adapter: `refs/fizzy/` (`config/database.*.yml`, `lib/fizzy.rb`).

---

## Background jobs

**Options**
- **Solid Queue** *(default)* — jobs are rows in a dedicated `queue` database. No broker to
  run. Enqueue happens in a DB transaction, so pair enqueues with `after_*_commit`. Dashboard
  via mission_control-jobs behind your own auth.
- **Resque + resque-pool (Redis)** — only if you already operate Redis or have a scale story
  that needs it. Drags in Redis purely for the queue; fork-safety boilerplate is on you.

**Default:** Solid Queue, on its own database connection.

Either way, keep jobs **shallow**: `perform` is one line delegating to a model/PORO, named
via a `*_later` method on the model. (Job design depth → models/testing skills.)

**Read:** Solid Queue: `refs/fizzy/config/environments/production.rb`, `refs/upright/lib/upright/engine.rb`.
Resque: `refs/writebook/Procfile`, `refs/once-campfire/Gemfile`.

---

## Real-time adapter (Action Cable)

**Options**
- **solid_cable** *(default)* — broadcasts are rows in a dedicated `cable` database, polled at
  a short interval. No Redis. Matches the Solid Queue story.
- **Redis adapter** — only if you already run Redis or need its pub/sub characteristics.
  Namespace keys with `channel_prefix` if the Redis instance is shared.

**Default:** solid_cable.

Most real-time needs no custom channel: prefer `turbo_stream_from` + `Turbo::StreamsChannel`,
and let **stream names be the authorization boundary** (name them after tenant-owned records).
(Real-time depth → frontend skill.)

**Read:** solid_cable: `refs/fizzy/config/cable.yml`. Redis: `refs/writebook/config/cable.yml`.

---

## Multi-tenancy

**Options**
- **Single-tenant** *(default)* — one install, one account. `Current.account` returns the one
  row; enforce "exactly one" with a `singleton_guard` integer column + unique index, not an
  app-level validation. No account scoping anywhere because there is one account.
- **Subdomain** — tenant resolved from `request.subdomain` in a `before_action` into a
  `Current` attribute; route with constraint lambdas; session cookie `domain: :all` and
  `tld_length = 1` so auth survives the cross-subdomain hop.
- **URL-path (`/:account_id/...`)** — Rack middleware moves the slug into `SCRIPT_NAME` so all
  URL helpers auto-prefix; resolve and set `Current.account` per request; data isolation via
  `account_id` on every model. Background/broadcast jobs must **re-establish account context**
  (capture `Current.account` at enqueue, restore around `perform`).

**Default:** single-tenant. Adopt subdomain or path tenancy only for genuine multi-tenant SaaS.

**Read:** single-tenant: `refs/writebook/app/models/current.rb`, `refs/once-campfire/db/schema.rb`
(singleton_guard). Subdomain: `refs/upright/` (`config/routes.rb`, `app/controllers/concerns/upright/subdomain_scoping.rb`).
Path: `refs/fizzy/config/initializers/tenanting/`, `refs/fizzy/app/jobs/concerns/account_tenanted.rb`.

---

## Email

**Options**
- **Full ActionMailer** — when you must reach people who aren't currently logged in
  (password reset, invitations to non-users, receipts/invoices, magic links) or need durable
  records. Multipart (html + text), tenant-aware URLs, one-click unsubscribe headers.
- **No transactional email** — when the app *is* the destination and users are logged-in
  device owners. Replace email with Web Push (VAPID + service worker) for nudges and **in-app
  shareable links** (a `signed_id` magic link or a rotating join code surfaced as copy/QR/
  web-share) for invites and recovery.

**Default:** start with **none**; add ActionMailer the moment a flow must reach a non-logged-in
human. This is a domain decision, not an anti-mailer stance — don't generalize "no email" past
apps where the user lives inside the app.

**Read:** no-email substitutes: `refs/once-campfire/` (Web Push: `lib/web_push/`, PWA),
`refs/writebook/app/models/account/joinable.rb` (join code), `refs/writebook/app/models/user/transferable.rb`
(signed_id recovery). Full mailer: `refs/fizzy/app/mailers/`.

---

## Deployment

**Options**
- **Kamal** *(default)* — single-server or multi-DC container deploy. SQLite volume, optional
  `SOLID_QUEUE_IN_PUMA` to co-locate jobs, secrets fetched at deploy time (not committed).
- **Procfile + `bin/boot` + Thruster** — `bin/boot` is a hand-written ~50-line supervisor
  (PID 1) that parses the `Procfile` and spawns each process (web + workers, + Redis if used)
  in one container; the Procfile's `web` line runs Puma behind **Thruster**, a Go proxy doing
  TLS/HTTP2/asset acceleration in place of nginx. Choose when you want one self-contained image
  without Kamal's orchestration.

**Default:** Kamal.

Common to both: log to STDOUT (container-native), SSL on by default but ENV-overridable
(`DISABLE_SSL`/`ASSUME_SSL`), surface the build version from ENV as a response header, broaden
filtered parameters well beyond `password`, enable YJIT, run jemalloc in the container.

**Read:** Kamal: `refs/fizzy/config/deploy.yml`. Procfile/Thruster: `refs/writebook/Procfile`,
`refs/writebook/bin/boot`, `refs/writebook/Dockerfile`.
