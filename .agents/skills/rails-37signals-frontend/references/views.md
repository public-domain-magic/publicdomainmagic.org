# ERB, partials & helpers (depth)

## Partials take locals; `local_assigns` for optionals

A partial reads its data as locals and optional ones defensively, so it's callable from a page
render, a Turbo Stream response, and a model broadcast identically:

```erb
<%# _post.html.erb %>
<% unread = local_assigns.fetch(:unread, false) %>
<%= tag.article id: dom_id(post), class: class_names("post", unread:) do %> … <% end %>
```

Collection rendering uses the explicit long form so you can pass shared locals and cache:

```erb
<%= render partial: "posts/post", collection: @posts, as: :post, cached: true %>
```

`refs/writebook/app/views/`, `refs/fizzy/app/views/`.

## `dom_id(record, :aspect)` everywhere

One record has many addressable regions; the second arg namespaces them so frame ids, stream
targets, and `form="…"` references stay predictable and collision-free:

```erb
<turbo-frame id="<%= dom_id(post, :edit) %>"> … </turbo-frame>
<%= turbo_frame_tag dom_id(post, :comments), src: post_comments_path(post) %>
```

## Tiny, partial-driven Turbo Stream templates

```erb
<%# update.turbo_stream.erb — reuse the page's own partial %>
<%= turbo_stream.replace dom_id(@post) do %>
  <%= render "posts/post", post: @post %>
<% end %>
```

`destroy.turbo_stream.erb` is one line (`turbo_stream.remove @post`). The partial is the single
source of truth for that fragment; a live update is "replace this with its freshly rendered self."
`refs/once-campfire/app/views/messages/create.turbo_stream.erb`, `refs/writebook/app/views/`.

## One layout, many "layouts"

```erb
<main id="main" class="<%= @layout_class %>"><%= yield %></main>
<header id="header"><%= yield :header %></header>
<aside  id="sidebar"><%= yield :sidebar %></aside>
```

Each page sets `@layout_class` and fills regions with `content_for`. Slots stay in the DOM even when
empty so CSS can size the grid. A partial whose whole job is to push into `:header`/`:toolbar` slots
(rendering no inline output) is a fine, reusable way to compose regions.
`refs/writebook/app/views/layouts/application.html.erb`.

## Fragment caching keyed on authorization

```erb
<% cache [ @post, @post.editable? ] do %> … <% end %>   <%# editor and reader cache separately %>
```

A naive `cache @post` would serve a reader the editor's controls. Pull the dynamic per-user bit
(e.g. a bookmark) into a lazy `turbo_frame_tag … src:` so the surrounding markup *can* be cached.
`refs/writebook/app/views/books/show.html.erb`.

## Helpers are tag-building DSLs

```ruby
# app/helpers/posts_helper.rb
def post_article_tag(post, **options, &block)
  classes = class_names("post", "post--archived" => post.archived?, "post--pinned" => post.pinned?)
  tag.article id: dom_id(post), class: classes,
    style: "--post-color: #{post.color}", data: { controller: "post" }, **options, &block
end
```

State→class mapping and `data-*` Stimulus wiring live in the helper; the template calls
`post_article_tag post do … end`. Push appearance into CSS custom properties via `style:` so CSS,
not Ruby, decides looks. `refs/fizzy/app/helpers/cards_helper.rb`,
`refs/once-campfire/app/helpers/messages_helper.rb`.

### Composing Stimulus data without clobbering

```ruby
def auto_submit_form_with(**attributes, &)
  data = attributes.delete(:data) || {}
  data[:controller] = "auto-submit #{data[:controller]}".strip   # compose, don't overwrite
  form_with(**attributes, data:, &)
end
```

Build long action strings from named pieces and `join(" ")`; never inline a 200-char `data-action`
in ERB. `refs/once-campfire/app/helpers/`, `refs/writebook/app/helpers/forms_helper.rb`.

### Client-side time; safe HTML; tiny ApplicationHelper

```ruby
def local_datetime_tag(datetime, style: :time, **attributes)
  tag.time datetime: datetime.iso8601, data: { local_time_target: style }, **attributes
end
```

Let a `local-time` Stimulus controller render it in the viewer's zone. For HTML that must be marked
safe, **escape first, then mark** (`ERB::Util.html_escape(x).gsub(...).html_safe`); use `safe_join`
for arrays of tags — never `html_safe` raw user input. Keep `ApplicationHelper` to global primitives
(`icon_tag`, `page_title_tag`); one module per resource otherwise. `refs/fizzy/app/helpers/time_helper.rb`.

### When presentation logic branches: a presenter PORO

When a helper would grow to 100 lines of branching, use a plain object given the view as `context:`
and delegating tag/url helpers to it — beats a giant helper method. (Not a ViewComponent; these apps
use plain partials + helpers + the occasional presenter PORO, no component library.)
`refs/once-campfire/app/helpers/messages/attachment_presentation.rb`.
