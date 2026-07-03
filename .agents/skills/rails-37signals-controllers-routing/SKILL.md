---
name: rails-37signals-controllers-routing
description: >
  Use when writing or editing controllers, routes, or request handling in a Rails app built the
  37signals / Omakase way: actions, before_action loaders, strong params, response formats,
  route declarations, and URL helpers. Covers thin controllers that call one domain method,
  RESTful-only routing (invent a resource instead of a custom action), structural authorization
  by scoping queries through Current (404 not 403), scope module: vs namespace, multi-format
  (Turbo Stream + HTML/JSON) responses, params.expect, built-in rate_limit, and direct/resolve
  URL helpers. Trigger when the user says "add a controller/route/endpoint," "handle this form,"
  "add an action like publish/archive/approve," "nest these routes," or "lock down this action."
  Do NOT use for auth internals (auth skill), domain logic (models skill), or views (frontend skill).
---

# Controllers & routing, the 37signals way

Controllers carry **no logic**. An action loads a record (scoped to the current user), calls **one
intention-revealing model method**, and renders. The verb lives on the model; the controller
translates HTTP into a model call.

Examples use a neutral `Post`/`Project`/`Comment` domain. `refs/` (`fizzy`, `once-campfire`,
`writebook`, `upright`) is ground truth — **lift the mechanism, translate the noun.**

## RESTful-only: invent a resource, never a custom action

The defining rule: every controller exposes only the standard seven actions. When a verb doesn't
map to CRUD, **create a resource named for the noun** instead of adding `post :publish`. Publishing
a post is *creating a `Publication`*; reopening is *destroying a `Closure`*; archiving is *creating
an `Archival`*.

```ruby
# config/routes.rb
resources :posts do
  scope module: :posts do
    resource :publication, only: %i[ create destroy ]   # create = publish, destroy = unpublish
    resource :archival,    only: %i[ create destroy ]
  end
end
```

Use **singular `resource`** (no `:id`, no index) for one-per-owner concepts. Each gets a tiny
two-method controller. You will be tempted to add `def publish` to `PostsController` — don't; make
`Posts::PublicationsController`. This is why these apps have many small controllers, and it's the
single most important convention here.

`scope module:` nests the **controller** into a namespace folder **without** adding a URL segment
(`Posts::PublicationsController` at `/posts/:post_id/publication`). Use `namespace` only when you
want the URL segment *and* the module. `refs/fizzy/config/routes.rb`,
`refs/once-campfire/config/routes.rb`.

## Authorization is structural: scope through `Current`, get a 404

Don't write permission checks where a scoped query will do. Reach every record through the current
user so an inaccessible id raises `RecordNotFound` (404) — never a 403 that confirms the record
exists. Factor the load into a small `*Scoped` concern:

```ruby
# app/controllers/concerns/post_scoped.rb
module PostScoped
  extend ActiveSupport::Concern
  included { before_action :set_post }

  private
    def set_post
      @post = Current.user.posts.find(params[:post_id])   # scoped → authorization is the query
    end
end
```

`Current.user.posts.find(...)`, never a bare `Post.find`. The scope *is* the authorization. A
`*Scoped` concern also holds the family's shared render/refresh helpers. When a query can't encode
the rule, fall back to a one-line predicate guard from the **auth skill**
(`before_action :ensure_can_administer`). `refs/once-campfire/app/controllers/concerns/room_scoped.rb`,
`refs/fizzy/app/controllers/concerns/card_scoped.rb`, `refs/writebook/app/controllers/concerns/book_scoped.rb`.

## Respond to multiple formats in one action

A mutating action answers Turbo Stream and HTML (and JSON where there's an API) in one `respond_to`.
The HTML branch is a real fallback (redirect or `head :no_content`), not an afterthought, and the
branches may legitimately differ. Redirect after a non-GET mutation with `status: :see_other` (303)
so Turbo follows it.

```ruby
def update
  @post.update! post_params
  respond_to do |format|
    format.turbo_stream                                   # update.turbo_stream.erb
    format.html { redirect_to @post, status: :see_other }
    format.json { render :show }
  end
end
```

Real-time freshness for *other* users comes from model broadcasts; the **acting** user's immediate
response is the `.turbo_stream.erb` template (see the frontend skill).

## Strong params: `params.expect`, drop blanks deliberately

Use Rails 8 `params.expect` (not `require`/`permit`); `wrap_parameters` whitelists the JSON body.

```ruby
def post_params = params.expect(post: [ :title, :body, :status ])
```

`.compact` permitted params on update when a blank field should mean "leave unchanged" (e.g. don't
overwrite a password with `nil`). Coerce/whitelist enum-ish params at the edge with
`presence_in(%w[…])` rather than trusting the model. `refs/fizzy/app/controllers/cards_controller.rb`.

## Built-in rate limiting

Declarative, on the action, no gem:

```ruby
rate_limit to: 10, within: 3.minutes, only: :create, with: -> { head :too_many_requests }
```

## Cross-cutting setup via concerns on a near-empty base

`ApplicationController` is a manifest of `include`s (see foundation). **A small concern populates
request context onto `Current` in a `before_action`, so deep model/job code can read it without
threading params through every call.** How much it captures varies — fizzy's `CurrentRequest` sets
`request_id`/`user_agent`/`ip_address`; campfire's sets `Current.request`. Keep each concern to one
`before_action`/`helper_method` plus private guards.
`refs/fizzy/app/controllers/concerns/current_request.rb`.

## Conventions

- **Empty action bodies are explicit** (`def show` / `end`) — a house signal that the action exists
  and renders its template.
- **Instance-var only what the view needs**; `create` often returns a bare local, not `@post`.
- **Index can redirect** rather than list (e.g. to the user's last/most-relevant record).
- **Don't nest resources deeper than one level** — invent a resource or break the chain instead of
  `/posts/:post_id/comments/:id/replies`. Order `before_action`s so auth/scoping run before the
  action (concern include order decides this).

## Routing recipes → references

See **[`references/routing-recipes.md`](references/routing-recipes.md)** for: `direct`/`resolve`
URL helpers that build links from domain objects, the `my/` "current user as implicit resource"
namespace (and `scope defaults: { user_id: "me" }`), a cached unauthenticated `public/` read-only
mirror, typeahead/autocomplete endpoints as their own resources, and legacy-URL redirect lambdas.
