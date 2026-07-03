# Routing recipes (load when you need one)

## `direct` / `resolve`: build URLs from domain objects

Teach the router how to link a domain object so `link_to record` and `url_for(record)` just work —
instead of helper methods or manual `polymorphic_url`.

```ruby
# config/routes.rb
resolve("Comment") { |c, opts| [ c.post, opts.merge(anchor: dom_id(c)) ] }  # a comment links to its post + anchor
direct(:published_post) { |post| route_for(:public_post, post.publication.key) }
```

Use `direct` for a named URL computed from an object (e.g. a cache-busting asset URL that appends
`v=updated_at`, or a slugged path that pulls the slug off the model so callers pass only the
record). Use `resolve` to override what `url_for`/`link_to` produce for a class.
`direct` is used in all three of `refs/fizzy/config/routes.rb`, `refs/once-campfire/config/routes.rb`,
and `refs/writebook/config/routes.rb`; `resolve` appears only in `refs/fizzy/config/routes.rb`.

## `my/`: the current user as an implicit resource

Give "the signed-in user's own things" a namespace with **no `:id`** in the path — identity always
comes from `Current.user`.

```ruby
namespace :my do
  resource  :profile, :menu
  resources :bookmarks
end
```

Alternatively hardwire the id with `scope defaults: { user_id: "me" }` so `/users/me/profile` always
means the current user and the controller ignores the param, reading `Current.user`. Contrast with
a top-level `resources :users` (an admin managing *other* users) — distinct namespace, distinct
intent, distinct policy. `refs/fizzy/config/routes.rb` (`my/`),
`refs/once-campfire/config/routes.rb` (`defaults: { user_id: "me" }`).

## A cached, unauthenticated `public/` mirror

Published/shared resources get a parallel `only: :show` resource tree under `public/`, opting out of
auth, setting a public cache window, and looking records up by a *published key* instead of user
scope.

```ruby
namespace :public do
  resources :posts, only: :show do
    resources :comments, only: :show
  end
end
```

```ruby
class Public::BaseController < ApplicationController
  allow_unauthenticated_access
  before_action { expires_in 30.seconds, public: true }
  layout "public"
end
```

`refs/fizzy/app/controllers/public/base_controller.rb`, `refs/fizzy/config/routes.rb`.

## Typeahead / autocomplete as its own resource

Model the *use* as a namespace rather than bolting query params onto an existing controller. These
render `layout: false` and lean on `stale?`/etags.

```ruby
namespace :prompts do          # or :autocompletable
  resources :users, :projects
end
```

`refs/fizzy/config/routes.rb` (`prompts/`), `refs/once-campfire/config/routes.rb` (`autocompletable/`).

## Legacy URLs via inline redirect lambdas

Keep old paths working in `routes.rb` itself:

```ruby
get "/old/:id", to: redirect { |params, req| "#{req.script_name}/posts/#{params[:id]}" }
```

(Preserve `request.script_name` if the app uses URL-path multi-tenancy, so the redirect keeps the
tenant prefix.) `refs/fizzy/config/routes.rb`.

## One sanctioned custom action

The rare exception to RESTful-only: a collection-level verb with no single id to act on, e.g.
`delete :clear, on: :collection` to wipe a user's saved searches. Even searching is modeled as a
resource (`create` saves a search, `index` lists). Reach for this only when inventing a resource
genuinely doesn't fit. `refs/once-campfire/config/routes.rb`.
