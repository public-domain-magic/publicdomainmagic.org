---
name: rails-37signals-auth
description: >
  Use when adding or modifying authentication, sessions, sign-in/sign-out, signup, password
  handling, "remember me," magic links, invitations, API/bot access, or authorization
  ("who can do what," admin checks, per-record permissions) in a Rails app built the
  37signals / Omakase way. Covers the hand-rolled, Rails-8-native auth pattern — fail-closed
  before_action with opt-out macros, a database-backed Session row, has_secure_password,
  authenticate_by, signed_id links, and authorization as plain predicates or a join model.
  Trigger even when the user says "add login," "lock this down," "let only admins…,"
  "passwordless," or "invite users" without naming a library. Do NOT use to choose the
  stack (foundation skill) or for non-Rails auth. Never reach for Devise, Pundit, or CanCan.
---

# Authentication & authorization, the 37signals way

Auth here is **hand-rolled on the Rails 8 native pattern** (`bin/rails generate authentication`
taken to production). No Devise, no Pundit, no CanCan, no OmniAuth unless an external IdP is a
hard requirement. The whole system is a few hundred lines of plain Rails.

Examples use a neutral `Post`/`Project`/`User` domain. `refs/` (`once-campfire`, `writebook`,
`fizzy`, `upright`) is ground truth — **lift the mechanism, translate the noun.** The cleanest
end-to-end reference is `refs/writebook/` and `refs/once-campfire/` (both hand-roll the native
pattern).

## The keystone: fail closed

Authentication is required by default; controllers opt **out**. This is the inverse of bolting
auth on, and it's the single most important move — forgetting a guard locks a page down, never
leaks it.

```ruby
# app/controllers/concerns/authentication.rb
included do
  before_action :require_authentication
end

class_methods do
  def allow_unauthenticated_access(**options)         # public pages
    skip_before_action :require_authentication, **options
    before_action :restore_authentication, **options  # writebook: still resume a session if present
  end

  def require_unauthenticated_access(**options)        # signup/login: must be logged OUT
    allow_unauthenticated_access **options
    before_action :redirect_signed_in_user_to_root, **options
  end
end
```

```ruby
# app/controllers/sessions_controller.rb — the sign-in page is reachable while logged out
class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
end
```

The concern **exposes its own class-method DSL** — controllers read `allow_unauthenticated_access
only: :show`, not raw `skip_before_action` at every call site. In writebook, opting out of
*requiring* a session still **restores** one if the cookie is present, so "public" ≠ "anonymous": a
public page can greet a signed-in visitor. (once-campfire's `allow_unauthenticated_access` is the
bare `skip_before_action` — the restore step is the version worth copying.) Sessions are created
and torn down by helper methods (`start_new_session_for`, `terminate_session`) that set or delete
both the cookie and the row.

`refs/once-campfire/app/controllers/concerns/authentication.rb`,
`refs/writebook/app/controllers/concerns/authentication.rb`.

## The session is a database row, not a cookie payload

Default. The cookie carries only an opaque token; the token names a `Session` row.

```ruby
# app/models/session.rb
class Session < ApplicationRecord
  belongs_to :user
  has_secure_token   # generates `token`, unique-indexed — the secret is the token, not the user id
end

# app/controllers/concerns/authentication/session_lookup.rb
def find_session_by_cookie
  Session.find_by(token: cookies.signed[:session_token]) if cookies.signed[:session_token]
end
```

```ruby
# set on login — signed, httponly, lax, permanent
cookies.signed.permanent[:session_token] = { value: session.token, httponly: true, same_site: :lax }
```

Why this beats stuffing `user_id` in the cookie: **revocation is real** (delete the row → logged
out everywhere next request; `user.deactivate` does `sessions.delete_all`), sessions are
**auditable** (each row carries `user_agent`, `ip_address`, `last_active_at` — a "your devices"
list for free), and a forged token resolves to `nil`. `signed` (not `encrypted`) suffices because
the token is meaningless without the row.

**Throttle activity writes** — update `last_active_at` at most hourly, not every request:

```ruby
# app/models/session.rb
def resume(user_agent:, ip_address:)
  if last_active_at.before?(1.hour.ago)
    update! user_agent:, ip_address:, last_active_at: Time.now
  end
end
```

`refs/writebook/app/models/session.rb`, `refs/once-campfire/app/models/session.rb`.

> **Decide-once fork — session store.** DB-backed `Session` row (above) is the default: revocable,
> auditable, "sign out other devices." Use a **stateless signed cookie** instead *only* when auth
> is fully delegated to an external IdP and you don't need server-side revocation (you accept a
> leaked cookie is valid until expiry). See `references/variations.md`.

## `Current` derives the user from the session

Set the session once; the user falls out (see also the foundation/models skills). Controllers never
assign `Current.user` directly.

```ruby
# app/models/current.rb
def session=(value)
  super
  self.user = session.user if value.present?
end
```

## Passwords: `has_secure_password validations: false`, timing-safe sign-in, built-in rate limit

```ruby
# app/models/user.rb
has_secure_password validations: false   # users may exist without a password (invited/bot/transferred)
```

```ruby
# app/controllers/sessions_controller.rb
rate_limit to: 10, within: 3.minutes, only: :create     # Rails 8 built-in, no gem

if user = User.authenticate_by(email_address: params[:email_address], password: params[:password])
  start_new_session_for user
```

`authenticate_by` (Rails 7.1+) runs bcrypt even when the email is unknown, so response time
doesn't reveal whether an account exists — never hand-roll `find_by` + `authenticate`. Scope it
(`User.active.authenticate_by…`) so deactivated users can't sign in. `validations: false` drops
the built-in presence/confirmation rules so the form owns its own UX and password-less records stay
valid.

## Magic links & recovery: `signed_id`, no token table

Time-boxed, purpose-scoped tokens — no token columns, no expiry sweeps, no mailer record. The state
*is* the signature.

```ruby
# app/models/user/transferable.rb
def transfer_id            = signed_id(purpose: :transfer, expires_in: 4.hours)
def self.find_by_transfer_id(id) = find_signed(id, purpose: :transfer)
```

`purpose:` scopes the signature so a transfer link can never be replayed as an avatar or
unsubscribe token — and the same mechanism covers password reset and signed asset URLs.
`refs/writebook/app/models/user/transferable.rb`,
`refs/once-campfire/app/models/user/transferable.rb`.

## Authorization: predicates, not a policy framework

Reach for the simplest thing that fits. **Most checks are a predicate** on the user/record plus a
one-line guard concern:

```ruby
# app/models/user/role.rb
enum :role, %i[ member administrator ], default: :member
def can_administer? = administrator?     # add `|| self == record&.creator` if record owners administer

# the guard concern (writebook files it under app/models/concerns/, campfire under app/controllers/concerns/)
def ensure_can_administer = head(:forbidden) unless Current.user.can_administer?
```

Phrase as a **capability** (`can_administer?`), so callers ask "can this user do X," not "is this
user an admin." Reach for Pundit/CanCan only when policies are numerous and shared across many
resources; two questions plus the per-record check below are less code than a DSL.

**When authorization is genuinely data-driven** (per-record, granted/revoked), use an explicit
**join model with a level enum**, and let the same table power both the predicate and the listing
query so they can't drift:

```ruby
# app/models/access.rb            level enum: reader/editor; belongs_to :user, :project
# app/models/project/accessable.rb
def editable?(user: Current.user) = access_for(user:)&.editor? || user&.administrator?
```

Note the `|| administrator?` — the one place the global role bypasses the join table. Reconcile
sets in bulk (`upsert_all` + `delete_all`), not per-row callbacks.
`refs/writebook/app/models/access.rb`, `refs/writebook/app/models/project/accessable.rb` (real:
`book/accessable.rb`).

The most common authorization is **structural**, not a check at all: reach every record through
`Current.user` (`Current.user.posts.find(...)`) so an inaccessible id raises `RecordNotFound` (404),
never a 403 that confirms the record exists. That lives in the **controllers-routing skill**.

**Testing auth:** sign in with a real login helper (a `sign_in` that POSTs credentials and asserts
the cookie), never by stubbing `Current.user` — see the testing skill.

## More: bots/API keys, invitations, first-run, the WebSocket

These are common but not every app needs them — see **[`references/variations.md`](references/variations.md)**:
the session-store fork in depth, external-IdP/OmniAuth, API-key auth for bots/programmatic clients
(+ conditional CSRF), shared-join-code vs per-email invitations, first-run admin bootstrap, and
authenticating the Action Cable connection off the same cookie.

