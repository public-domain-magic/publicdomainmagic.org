# Domain-layer patterns (load when you need one)

## Full-text search: SQLite FTS5, no Elasticsearch / pg_search

Search is a virtual table kept in sync by commit callbacks and queried with `MATCH`. The index is
**not** an AR model; callbacks fire raw SQL keyed on `rowid = <table>.id`.

```ruby
# migration — the schema-statement API; this plain (non-external-content) form round-trips into schema.rb
create_virtual_table :post_search_index, :fts5, [ "title", "body", "tokenize=porter" ]

# app/models/post/searchable.rb
included do
  after_create_commit  :create_in_index
  after_update_commit  :update_in_index
  after_destroy_commit :remove_from_index
  scope :search, ->(q) {
    joins("join post_search_index idx on posts.id = idx.rowid").where("idx.body match ?", q)
  }
end
```

Index plain text (`body.to_plain_text`), not HTML. `tokenize=porter` gives stemming. Cost vs a
declarative `has_many`: you maintain the index in callbacks — but it's free, in-process, and ships
with SQLite. (Only *external-content* FTS5 — `content=`/`content_rowid=` — needs a custom schema
dumper; the plain form above doesn't.) `refs/once-campfire/app/models/message/searchable.rb`,
`refs/writebook/app/models/leaf/searchable.rb`.

## Ordering: fractional `position_score` with rebalance

Not an integer `position` column (which renumbers N rows on every move). A float `position_score`,
ordered `(:position_score, :id)`. Inserting computes a score *between* neighbors, so a reorder
touches one row; when the gap underflows a threshold, rewrite all scores in one SQL window update.

```ruby
# app/models/concerns/positionable.rb  (shared across unrelated models)
scope :positioned, -> { order(:position_score, :id) }
around_create     :insert_at_default_position
after_save_commit :rebalance_positions, if: :rebalance_required?
```

A `positioned_within :project, association: :items` class macro lets the model declare its parent
so the concern stays generic. Serialize concurrent moves with `parent.with_lock`.
`refs/writebook/app/models/concerns/positionable.rb`, `app/models/leaf.rb`.

## SSRF-safe outbound fetch (any app fetching user-supplied URLs)

Never trust a URL. Resolve the host once, reject private/loopback/link-local ranges, **pin the
connection to the resolved IP** (closes the DNS-rebind window), re-guard every redirect, and cap
body size by streaming.

```ruby
# lib/restricted_http/private_network_guard.rb
def private_ip?(ip)
  a = IPAddr.new(ip)
  a.private? || a.loopback? || a.link_local? || a.ipv4_mapped? || LOCAL_IP.include?(a)
rescue IPAddr::InvalidAddressError
  true   # fail closed
end

# app/models/.../fetch.rb
Net::HTTP.start(url.host, url.port, ipaddr: resolved_ip, use_ssl: url.scheme == "https")  # pinned
```

`refs/once-campfire/lib/restricted_http/private_network_guard.rb`,
`refs/once-campfire/app/models/opengraph/fetch.rb`.

## Tableless / non-AR models

Not every "model" is ActiveRecord. Keep them in `app/models`:

- **`ActiveModel::Model` object with no table** — carries attributes through a request, gives forms
  an ActiveModel-shaped object, validates. Right when identity comes from elsewhere (an external
  IdP) or the thing is a form, not a row.
- **Config/value object** — e.g. an `HtmlScrubber < Rails::Html::PermitScrubber` subclass, a
  signed-URL wrapper over `ActiveSupport::MessageVerifier`, a bootstrap/seeder class.
- **`Current < ActiveSupport::CurrentAttributes`** — request-scoped context (see auth/foundation).

Treat AR as the expensive choice and reserve it for genuinely persisted, high-value rows; read-side
aggregates and external-process wrappers stay POROs. `refs/upright/` is the extreme case (one AR
table, everything else a PORO) — instructive but monitoring-specific; don't over-apply.

## PORO taxonomy (when logic outgrows a concern)

- **`<Model>::<Thing>` PORO** — multi-step transformation with private helpers; subject in
  `initialize`, one public verb. `app/models/post/activity_spike_detector.rb`.
- **`<Model>::<Thing>` under a concern's namespace** — when a concern delegates to a helper object:
  e.g. a `SystemCommenter` at `app/models/post/eventable/system_commenter.rb`, called from
  `Post::Eventable`.
- **`.for(subject)` factory** — returns a type-specific subclass via `safe_constantize`, or `nil`.
  Recurs for notifiers, value computations, sharded lookups.

The rule: a concern adds methods to the model; when the logic is a multi-step transformation with
its own state/helpers, give it its own object instead. `refs/fizzy/app/models/card/` is full of
these (`entropy.rb`, `activity_spike/detector.rb`, `eventable/system_commenter.rb`).
