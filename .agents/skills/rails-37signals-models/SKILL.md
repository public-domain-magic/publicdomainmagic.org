---
name: rails-37signals-models
description: >
  Use when designing or editing the domain layer of a Rails app built the 37signals / Omakase
  way: ActiveRecord models, concerns, enums, associations, callbacks, and the plain Ruby objects
  that hold business logic. Covers the core organizing move — fat behavior split into capability
  concerns namespaced under the model — plus request-scoped Current defaults, POROs instead of a
  service layer, delegated_type over STI, string-vs-integer enums, association-extension write
  APIs, after_commit discipline, and the bang/method-ordering conventions. Trigger when the user
  says "add a model," "where should this logic go," "extract this," "add a status/state,"
  "model this relationship," or reaches for a service object. Do NOT use for controllers/routing,
  auth specifics, or views. There is NO app/services/ layer.
---

# The domain layer, the 37signals way

Fat models, thin everything else — but "fat model" does **not** mean a 400-line god object. It
means a thin class that is a **manifest of capability concerns**, each owning one behavior end to
end, plus plain Ruby objects for anything too procedural to be a concern.

Examples use a neutral `Post`/`Project`/`Comment` domain. `refs/` (`fizzy`, `once-campfire`,
`writebook`, `upright`) is ground truth — **lift the mechanism, translate the noun.** The richest
model trees are `refs/fizzy/app/models/card*` and `refs/once-campfire/app/models/`.

## The core move: capability concerns namespaced under the model

Split a model into many small concerns. Each lives in a folder named after the model and is
namespaced under it — **not** in `app/models/concerns/`. The model `include`s them all in one
alphabetized line and reads as a table of contents.

```ruby
# app/models/post.rb
class Post < ApplicationRecord
  include Publishable, Archivable, Commentable, Searchable
end
```

```ruby
# app/models/post/publishable.rb   →   module Post::Publishable
module Post::Publishable
  extend ActiveSupport::Concern

  included do
    has_one :publication, dependent: :destroy
    scope :published, -> { joins(:publication) }
  end

  def publish(by: Current.user)
    transaction { create_publication!(publisher: by); track_event :published }
  end
end
```

Rails autoloading resolves `Publishable` to `Post::Publishable` because `Post` is the lexical
scope. The whole capability — associations, scopes, callbacks, methods, and its feature constants —
moves and deletes as one file. To learn "how does publishing work," you open one file.

Conventions inside concerns:
- Use `included do` for the feature's own AR macros (`has_one`, `scope`, `enum`, callbacks).
- Use `class_methods do` for the feature's class API; a **bare module** (no `extend
  ActiveSupport::Concern`) is fine when the concern only adds instance methods.
- Put feature constants at the **top of their own concern**, not on the host class.
- A concern decomposes like a class: extract a narrow reusable seam into a nested namespaced
  concern (`Post::Publishable` may `include SomethingNarrow`).

`app/models/concerns/` is reserved for behavior **genuinely shared across unrelated models**
(`Positionable`, a generic `Searchable`). When a model uses one, wrap it in a model-namespaced
concern that supplies the contract, so the model includes its own wrapper, never the shared module
directly:

```ruby
# app/models/post/searchable.rb
module Post::Searchable
  extend ActiveSupport::Concern
  included { include ::Searchable }       # the cross-model engine
  def search_title = title                # the host fulfills the shared contract
  def searchable?  = published?
end
```

`refs/fizzy/app/models/card.rb` (+ `app/models/card/*`), `refs/once-campfire/app/models/user.rb`,
`refs/fizzy/app/models/concerns/searchable.rb` + `app/models/card/searchable.rb`.

## Model state as a row, and `Current` as the default actor

State that carries who/when becomes **its own record**, not a boolean column — `published?` is
`publication.present?`, not a `published` flag. And ownership is a model invariant, not controller
boilerplate:

```ruby
belongs_to :author, class_name: "User", default: -> { Current.user }
```

The default fires only when unset, so an explicit `author:` still wins. Models read `Current.user`
directly (set once from the session — see auth/foundation), so controllers never thread it down.
`Current` itself is a tiny `ActiveSupport::CurrentAttributes` (`attribute :session, :user`) whose
`session=` cascades to `user`, reset between requests. Normalize input on the model
(`normalizes :email_address, with: ->(e) { e.strip.downcase }`) instead of scattering it across
call sites. `refs/once-campfire/app/models/message.rb`, `refs/fizzy/app/models/card.rb`.

## Domain logic in model methods + POROs, not a service layer

Controllers call **one intention-revealing model method** (`post.publish`, `project.archive`),
never assemble a domain operation from attribute writes. Services aren't a special artifact here —
when one is genuinely justified it's fine, but reach first for a model method or a **plain Ruby
object namespaced under its model** (`Post::ActivitySpikeDetector` at `app/models/post/…`), never a
free-standing `app/services/`. Shapes: a model method in a `transaction` for a multi-step mutation;
a PORO taking its subject in `initialize` and exposing one verb; an `ActiveModel::Model` form
object for cross-model flows; a `.for(subject)` factory that `safe_constantize`s a subclass. Full
taxonomy with examples in [`references/patterns.md`](references/patterns.md).
`refs/once-campfire/app/models/room/message_pusher.rb`, `refs/fizzy/app/models/signup.rb`.

## delegated_type over STI for content variants

When one thing has several shapes, prefer `delegated_type` (separate tables, no sparse shared
table) over STI:

```ruby
# app/models/item.rb
delegated_type :itemable, types: %w[ Article Image Embed ], dependent: :destroy
```

Each variant `include`s the reverse concern (`has_one :item, as: :itemable, touch: true`,
`delegate :title, to: :item`). STI is fine for near-identical siblings, but reach for
`delegated_type` by default. `refs/writebook/app/models/leaf.rb`, `app/models/leafable.rb`.

## Enums: match backing to whether the DB value should be legible

```ruby
enum :status, %w[ draft scheduled live ].index_by(&:itself)   # string-backed: rows read as words
enum :kind,   [ :ok, :fail ]                                  # integer-backed: legibility doesn't matter
```

String-backed (`index_by(&:itself)`, so the stored value equals the label) when you want readable
rows and safe reordering; integer-backed array form otherwise. Add `prefix:`/`suffix:` to avoid
scope collisions. `refs/writebook/app/models/book.rb`, `refs/upright/app/models/upright/probe_result.rb`.

## Associations own their write API; callbacks fire after commit

Expose domain verbs on the association, wrapping bulk writes once at the seam:

```ruby
has_many :memberships, dependent: :delete_all do
  def grant_to(users)   = insert_all(Array(users).map { { user_id: it.id, ... } })
  def revise(granted:, revoked:)
    transaction { grant_to(granted); destroy_by(user: revoked) }
  end
end
```

Callers say `project.memberships.grant_to(users)`, never assemble hashes. Use `insert_all`/
`upsert_all` for bulk (skips validations/callbacks deliberately, in one place).

Use `after_*_commit` (not `after_save`) for anything that enqueues a job, broadcasts, or touches
another system — so it never references a row the transaction rolled back. Domain events route
through the **owning model** (`post.comments.create!` → `post.notify_subscribers`), not the
controller. `refs/once-campfire/app/models/room.rb`, `refs/once-campfire/app/models/message.rb`.

## House conventions

- **`_later`/`_now`.** A model enqueues its own job through a `*_later` method; the job is a
  one-line shallow envelope calling back into the model. The suffix marks the sync/async boundary.
- **Method order** (enforced house style): class methods, then public (with `initialize` first),
  then private; within a group, top-down by call order (a method appears above what it calls).
- **Scopes compose the read API.** Name eager-load bundles (`with_author`, `with_details`) so
  callers say `.with_author` instead of spelling out `includes`.
- `ApplicationRecord` stays lean — base behavior lives in concerns, not here (an app may still add
  one cross-cutting line, e.g. read-replica wiring).

## Heavier patterns → references

See **[`references/patterns.md`](references/patterns.md)** when you need: full-text search via
SQLite FTS5 (callbacks + raw SQL, no Elasticsearch), fractional `position_score` ordering with
rebalance (`Positionable`), an SSRF-safe outbound-fetch guard in the model layer, tableless
ActiveModel objects, and the full PORO taxonomy with examples.
