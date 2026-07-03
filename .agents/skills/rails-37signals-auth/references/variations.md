# Auth variations (load when the app needs one)

## Session-store fork, in depth

- **DB-backed `Session` row (default).** Revocable, auditable, per-device. Logout deletes the row;
  `user.deactivate` does `sessions.delete_all`. Choose this for anything with accounts.
- **Stateless signed cookie.** The whole session is `session[:user_info] = { … }` (Rails
  cookie-store-backed); each request rebuilds a PORO user from it. No server-side revocation — a
  leaked cookie is valid until `expire_after`. Choose **only** when identity is delegated to an
  external IdP and you don't need forced logout. `refs/upright/` does this (its engine configures
  `:cookie_store`; a normal app would use `config/initializers/session_store.rb`).

## External IdP (OmniAuth) — only when required

If the org mandates SSO/OIDC, the user can be a **stateless ActiveModel object with no table**:
`User.from_omniauth(auth)` builds it from `auth.info`; `Current.user` holds it for the request.
There is no signup, password reset, or users table. The OmniAuth **callback** skips CSRF
(`skip_forgery_protection only: :create`) because it arrives from the provider without a Rails
token; the request phase stays CSRF-protected via `omniauth-rails_csrf_protection`. Make the
provider pluggable by config. `refs/upright/app/models/upright/user.rb`,
`refs/upright/app/controllers/upright/sessions_controller.rb`.

## API-key / bot access (programmatic clients)

A second auth path alongside the cookie, both setting `Current.user`. (The reference app frames
this as *bots*: in `refs/once-campfire` the real names are `bot_key`, `User.authenticate_bot`,
`allow_bot_access`, and `authenticated_by.bot_key?` — generalized to `api_key`/`api_key?` below.)

```ruby
# app/controllers/concerns/authentication.rb
def require_authentication
  restore_authentication || api_key_authentication || request_authentication
end

def api_key_authentication
  if key = params[:api_key].presence
    if client = ApiClient.authenticate(key)   # e.g. "<id>-<token>" split + find
      Current.user = client
      set_authenticated_by(:api_key)
    end
  end
end
```

`set_authenticated_by` records *how* the request authenticated; store it as a
`ActiveSupport::StringInquirer` (`method.to_s.inquiry`) so call sites read `authenticated_by.api_key?`.
That flag drives policy: skip CSRF for API callers (`protect_from_forgery with: :exception, unless:
-> { authenticated_by.api_key? }`) and forbid them from human-only actions unless a controller opts
in (`allow_api_access`). `refs/once-campfire/app/models/user/bot.rb`,
`refs/once-campfire/app/controllers/concerns/authentication.rb`.

For abuse mitigation, banning can harvest a user's session IPs into a `bans` table and reject those
IPs in an early `before_action` (skip safe GET/HEAD; return `429`, not `403`, so you don't confirm
the ban). `refs/once-campfire/app/models/user/bannable.rb`,
`refs/once-campfire/app/controllers/concerns/block_banned_requests.rb`.

## Invitations: shared join code vs per-email token

- **Shared rotating join code (simplest).** The account holds one code
  (`SecureRandom.alphanumeric(12).scan(/.{4}/).join("-")` → `ABCD-EFGH-IJKL`); anyone with the URL
  `join/:join_code` self-registers; the controller compares the path segment to the stored code.
  Rotating the code revokes every outstanding link at once. No per-recipient token to mint or
  expire, no mailer. Tradeoff: anyone holding it can join until rotation.
  `refs/writebook/app/models/account/joinable.rb`, `refs/writebook/app/controllers/users_controller.rb`.
- **Per-email `signed_id` link.** When you must invite a specific address, mint
  `signed_id(purpose: :invite, expires_in: …)` — still no token table.

Recovery (no "forgot password" email): a self-service `signed_id(purpose: :transfer)` link the user
generates and keeps, surfaced in-app for copy/QR/web-share. Hitting it starts a session with no
password. `refs/writebook/app/controllers/sessions/transfers_controller.rb`.

## First-run: bootstrap the first admin with no auth

The chicken-and-egg the tutorials skip — the first user must be created before any user exists to
authorize it. Model setup as a resource guarded to disable itself once seeded:

```ruby
# app/controllers/first_runs_controller.rb
allow_unauthenticated_access
before_action :prevent_running_after_setup   # redirect home if User.any?
```

The login page redirects here when the users table is empty. `refs/writebook/app/controllers/first_runs_controller.rb`.

## WebSocket auth reuses the same cookie

Don't invent a per-socket token. The Action Cable connection includes the **same**
`SessionLookup` concern the controllers use and reads the identical signed cookie:

```ruby
# app/channels/application_cable/connection.rb
include Authentication::SessionLookup
identified_by :current_user

def connect
  self.current_user = find_session_by_cookie&.user || reject_unauthorized_connection
end
```

One auth surface for HTTP and the socket; logging out kills the socket's user.
`refs/once-campfire/app/channels/application_cable/connection.rb`,
`refs/writebook/app/channels/application_cable/connection.rb`.
