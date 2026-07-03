---
name: rails-37signals-frontend
description: >
  Use when building the front end of a Rails app the 37signals / Omakase way: ERB views, layouts,
  partials, view helpers, Stimulus controllers, CSS/assets, and Hotwire real-time (Turbo Frames &
  Streams). Covers server-rendered HTML with Turbo + Stimulus and no SPA framework, partials that
  take locals, helpers that build tags (not format strings), tiny single-purpose Stimulus
  controllers, hand-written CSS with native @layer and OKLCH tokens over Propshaft (no Tailwind,
  no build step), and model-broadcast real-time where the stream name is the authorization
  boundary. Trigger when the user mentions views, partials, layouts, helpers, Stimulus/JS
  behavior, CSS/styling/theming, Turbo Frames/Streams, live updates, or "make this update without
  a reload." Do NOT use to add React/Vue, a JS bundler, or Tailwind — none belong here. Defer
  controllers/routing, models, and auth to their skills.
---

# Front end, the 37signals way

The server renders HTML; **Turbo drives navigation and updates, Stimulus is glue, and there is no
SPA framework, no bundler, and no CSS framework.** Everything below is in service of HTML the
server rendered. Importmap + Propshaft, zero build step (see foundation).

Examples use a neutral `Post`/`Project`/`Comment` domain. `refs/` (`fizzy`, `once-campfire`,
`writebook`, `upright`) is ground truth — **lift the mechanism, translate the noun.** `refs/fizzy/`
is the deepest front end (≈60 Stimulus controllers, hand-rolled CSS system).

This SKILL gives the cross-cutting rules; each area has a reference file for depth.

## ERB & partials  → [`references/views.md`](references/views.md)

- **Partials take explicit locals, never reach for `@ivars`.** Read optionals with
  `local_assigns.fetch(:key, default)`. This is what lets one partial serve a full page, a Turbo
  Stream response, and a model broadcast unchanged.
- **`dom_id(record, :aspect)`** namespaces each addressable region of a record (`dom_id(post,
  :comments)`, `dom_id(post, :edit)`) so frames and stream targets stay collision-free.
- **Turbo Stream templates are 1–5 lines and reuse the page's own partial** — choose an action,
  name a target, delegate rendering to the canonical partial. If a stream template has markup, the
  markup belongs in a partial.
- **One layout, faked into many** via a body/`<main>` class set per page (`@layout_class`), with
  named `content_for` regions (`:header`, `:sidebar`, …) the layout yields. Don't write a second
  layout for a chrome variant.
- **Fragment-cache by default**, and key on authorization where the markup differs by viewer:
  `cache [ @post, @post.editable? ]`. Render collections with `cached: true`.
- **Lazy frames & morph survival.** Carve a per-user dynamic hole out of otherwise-cacheable markup
  with a lazy `turbo_frame_tag dom_id(post, :bookmark), src: …`; mark elements that must survive a
  morph/refresh with `data-turbo-permanent`; put `data: { turbo_frame: "_top" }` on links inside a
  frame that should navigate the whole page.

## View helpers  → [`references/views.md`](references/views.md)

- **Helpers build tags, not strings.** Almost every helper returns a `tag.*` element wired with the
  Stimulus `data-controller`/`data-action`/`data-*` attributes for one piece of UI, so templates
  stay declarative. Helpers are where Ruby meets the JS layer — not where text formatting or
  business logic lives.
- **Compose Stimulus `data`, never clobber it:** `data[:controller] = [data[:controller],
  "mine"].compact.join(" ")` (or `token_list`). Assume the caller already set one.
- **One helper module per resource; keep `ApplicationHelper` tiny** (global primitives only —
  `icon_tag`, `page_title_tag`). Mirror the `app/models` tree under `app/helpers`.
- **Time is client-side:** emit `<time datetime=…>` and let a Stimulus controller localize it;
  don't `strftime` for display (reserve server formatting for email/non-interactive surfaces).

## Stimulus  → [`references/stimulus.md`](references/stimulus.md)

- **Tiny, single-purpose, behavior-named controllers** (`autosave`, `copy_to_clipboard`, not
  `posts`). Most are 10–40 lines; when behavior grows, split into another controller, not flags.
- **Declarative API at the top** (`static targets/values/classes/outlets`), `#private` fields and
  methods for everything that isn't a Stimulus action/target/value, and **clean up in
  `disconnect()`** (every listener/observer/interval has a teardown).
- **Controllers talk via custom events** (`this.dispatch("done")`), wired in HTML — not direct
  references. Use **outlets sparingly**, only when one controller must call methods on another.
- **CSS class names come from `static classes`/the view, never hardcoded** in JS.
- Keep heavy/stateful logic in **plain ES classes** under `app/javascript/models/` or pure functions
  under `helpers/`; controllers stay thin glue. `lib/` holds self-contained subsystems/custom elements.

## CSS & assets  → [`references/css.md`](references/css.md)

- **Hand-written CSS over Propshaft. No Tailwind/Bootstrap/Sass, no Node, no build.** Modern native
  CSS does the work: nesting, `@layer`, `oklch()`, `:has()`, container queries, logical properties.
- **`@layer` governs the cascade** (e.g. `@layer reset, base, components, utilities`) so files can
  be glob-loaded alphabetically without specificity wars.
- **Two-tier OKLCH tokens:** raw channel triples (`--lch-*`) wrapped by semantic vars
  (`--color-ink: oklch(var(--lch-ink))`); **dark mode redefines only the raw channels** and every
  semantic token follows — no second stylesheet, no `.dark` sprinkled everywhere.
- **BEM for components + a small hand-rolled semantic utility layer**; a component's themeable knobs
  are **component-local custom properties** (`--btn-bg`), so variants set properties, not rules.

## Real-time (Turbo)  → [`references/realtime.md`](references/realtime.md)

- **Usually no custom channels** — most live updates ride Turbo's `Turbo::StreamsChannel` via
  `turbo_stream_from`. (A chat-grade app may still hand-write presence/typing channels; reach for
  one only when Turbo Streams genuinely can't express the need.)
- **The stream name *is* the authorization boundary** — name streams after tenant-owned records
  (`turbo_stream_from @project`), so a subscriber can only receive a stream they can already render.
- **Prefer `broadcasts_refreshes`** (Turbo 8 morphing) for page-level freshness; reserve targeted
  `broadcast_*_to [owner, :facet]` for small per-user trays. (Whether broadcasts originate in the
  model or the controller is a genuine fork — see the reference.)
- **Broadcast to *other* users from the model; render the acting user's own response from the
  controller's `.turbo_stream.erb`.** Where both render the same fragment, point them at the same
  partial so they can't drift.
- The WebSocket reuses the web session cookie (see auth). Background broadcast jobs must carry
  request/tenant context if the app needs it (see foundation's tenancy fork).

## What stays out

No React/Vue, bundler, or Tailwind/Sass; no `package.json` in the asset pipeline. A rich input is a
**form-associated Web Component** (or a Stimulus-wired element), not a JS-framework island. Reaching
for any of these means you've left the path.
