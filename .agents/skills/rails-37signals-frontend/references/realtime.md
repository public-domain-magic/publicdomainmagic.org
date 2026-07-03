# Real-time with Hotwire (depth)

The headline: most apps write **no custom Action Cable channels** — live updates ride Turbo's
built-in `Turbo::StreamsChannel`, and the web speaks HTML the page already understands. (A
chat-grade app like campfire is the exception, hand-writing presence/typing channels; reach for one
only when Turbo Streams genuinely can't express the need.)

## Subscribe with `turbo_stream_from`; the stream name is the auth boundary

```erb
<%= turbo_stream_from @project %>                 <%# per record %>
<%= turbo_stream_from @project, :activity %>      <%# per record + facet %>
<%= turbo_stream_from [ Current.account, :all_projects ] %>  <%# per-tenant collection %>
```

There is no "is this user allowed on this stream?" check in a channel class, because the only
channel is Turbo's. **Isolation comes from the stream name**: names are built from tenant-owned
records the view can already render, so a subscriber can only receive streams within their own
scope. Name streams accordingly — that *is* your authorization. `refs/fizzy/app/views/`,
`refs/writebook/app/views/`.

## Prefer `broadcasts_refreshes`; target only for trays

For a new app, the modern Turbo 8 default for page-level freshness is to let the model emit a
**refresh** signal on commit; subscribers re-fetch and morph — no per-change partials to maintain.
Whether the broadcast **originates** in the model (`broadcasts_refreshes`) or the controller
(`broadcast_*_to`) is a genuine fork: fizzy drives it from the model; campfire/writebook broadcast
from the controller. Pick one and stay consistent.

```ruby
# app/models/post/broadcastable.rb
included do
  broadcasts_refreshes                                              # refresh the [post] stream on CRUD
  broadcasts_refreshes_to ->(post) { [ post.account, :all_posts ] }  # also a tenant collection stream
end
```

Reserve **targeted** broadcasts for small per-user UI (a notifications tray) where morphing the
whole page is wrong:

```ruby
after_create_commit  -> { broadcast_prepend_later_to user, :notifications, target: "notifications" }
after_destroy_commit -> { broadcast_remove_to       user, :notifications }
```

`refs/fizzy/app/models/card/broadcastable.rb` (refresh),
`refs/fizzy/app/models/board/broadcastable.rb` (collection stream),
`refs/fizzy/app/models/notification.rb` (targeted tray).

## Model broadcasts for others; controller `.turbo_stream.erb` for the actor

Split is deliberate:

- **Other users'** freshness → model broadcast (`broadcasts_refreshes`, or `broadcast_*_to`).
- **The acting user's** immediate response → the controller renders `update.turbo_stream.erb`,
  surgical and targeted.

Where both render the same fragment, point them at the **same partial** so they can't drift (with
whole-page `broadcasts_refreshes` morphing there's no partial at all — the page just re-renders).
(One app deliberately broadcasts a transient signal — "being edited by" presence — from the *controller*
instead of the model, because it's a user action, not a persisted change. Altitude depends on
whether the thing persists.) `refs/fizzy/app/views/cards/update.turbo_stream.erb`,
`refs/writebook/app/controllers/leafables_controller.rb`.

## Connection auth & background context

- The connection reuses the **web session cookie** (`identified_by :current_user`); see the auth
  skill. One auth surface for HTTP and the socket. (campfire/writebook share a `SessionLookup`
  concern between controller and connection; fizzy inlines the same lookup.)
- `broadcast_*_later` enqueues Turbo jobs that run on a worker with **no request**. If the app needs
  request/tenant context to render (tenant-scoped URLs, `Current.account`), that context must be
  re-established in the job — see the foundation tenancy fork; for path/subdomain tenancy you
  `prepend` a context concern onto Turbo's own `Turbo::Streams::*Job` classes, and set
  `config.active_job.enqueue_after_transaction_commit = true` so a broadcast never fires for a
  rolled-back row. `refs/fizzy/app/jobs/concerns/account_tenanted.rb`,
  `refs/fizzy/config/initializers/active_job.rb`.

## Adapter

solid_cable (default) or Redis — chosen in the foundation skill's real-time fork, not here.

## Ephemeral presence without a presence system

"Someone is editing / just saved" can be a **self-removing broadcast**, not a tracked roster:
broadcast a small partial whose element carries `data-controller="autoremove"` and removes itself on
`animationend`, plus a `data-hide-from-user-id` so the actor's own browser suppresses its echo. No
heartbeat, no presence set. (Connection-counted presence with a TTL also exists in the chat app, but
that's chat-specific — don't reach for it unless you genuinely need a live roster.)
`refs/writebook/app/views/leaves/_being_edited_by.turbo_stream.erb`.
