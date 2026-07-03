# Stimulus & client JavaScript (depth)

## Shape of a controller

Tiny, single-purpose, **named for the behavior** it adds to whatever element it's on (`autosave`,
`auto_submit`, `copy_to_clipboard`, `web_share`), never for a model or page. Declarative API first,
privates after, cleanup always:

```js
export default class extends Controller {
  static targets = [ "input" ]
  static values  = { url: String }
  static classes = [ "saving" ]          // class names come from the view, never hardcoded

  connect()    { this.#observer = new IntersectionObserver(this.#onSee); this.#observer.observe(this.element) }
  disconnect() { this.#observer.disconnect() }   // every listener/observer/interval gets a teardown

  save() { this.element.classList.add(this.savingClass); /* … */ }

  #onSee = (entries) => { /* … */ }      // arrow field for a stable `this`; # = not part of the API
}
```

The public surface is exactly the Stimulus actions/targets/values/outlets; everything else is `#`
private. Wrap debounce/throttle once in `initialize()` so the wrapped fn is stable.
`refs/fizzy/app/javascript/controllers/`, `refs/once-campfire/app/javascript/controllers/`.

## Controllers talk via custom events, not references

```js
// touch_controller.js
this.dispatch("swipe-left")          // becomes "touch:swipe-left"; it doesn't know or care who listens
```

```erb
<div data-controller="touch" data-action="touch:swipe-left->carousel#next"> … </div>
```

The HTML is the integration layer. Use **outlets only** when one controller must *call methods on*
another (give the consumed controller a deliberate public accessor surface; keep the rest `#`).
`refs/fizzy/app/javascript/controllers/dialog_controller.js`,
`refs/once-campfire/app/javascript/controllers/`.

## Server data via meta tags; capability gating

- A `window.Current` mirror, populated once at boot from `<meta>` tags, lets any controller read
  `Current.user.id` without prop-drilling `data-*` onto every element.
- `static get shouldLoad() { return isTouchDevice() }` lets a controller decline to register where
  it makes no sense — cheaper than guarding every action. Controllers eager-load
  (`eagerLoadControllersFrom`); gate individually.
- Progressive enhancement in `connect()`: feature-detect and remove your own UI when unsupported
  (`this.element.hidden = !navigator.canShare`) rather than rendering a dead control.

`refs/once-campfire/app/javascript/initializers/current.js`,
`refs/fizzy/app/javascript/helpers/platform_helpers.js`.

## Where code lives

- `controllers/` — Stimulus controllers (thin glue).
- `helpers/` — **pure functions**, no DOM identity, no lifecycle (`debounce`, `nextFrame`,
  `isTouchDevice`). The litmus: no element, no lifecycle → helper, not controller.
- `models/` — **plain ES classes** holding stateful logic (an uploader, a paginator, a formatter).
  Controllers instantiate and drive them; the algorithm isn't trapped in lifecycle hooks. This
  mirrors fat-model/thin-controller on the client.
- `lib/` — larger self-contained subsystems and custom elements.

`refs/once-campfire/app/javascript/models/`, `refs/fizzy/app/javascript/helpers/`.

## Talking to the server

- `@rails/request.js` for fetches, with `responseKind: "turbo-stream"` so the server replies with a
  stream the page applies — not hand-rolled `fetch`.
- Native `requestSubmit()` for anything already a form.
- Raw `XMLHttpRequest` **only** where you need `upload.onprogress` (file upload progress); `fetch`
  can't report it.

## Custom Turbo Stream actions (server-driven effects)

Extend Turbo with app-specific verbs when the server needs to trigger a *behavior* (scroll,
animate), not a DOM mutation — define a `Turbo.StreamActions.foo` (JS) paired with a Ruby builder
`prepend`ed onto `Turbo::Streams::TagBuilder`:

```js
// app/javascript/actions/scroll_into_view.js
Turbo.StreamActions.scroll_into_view = function () {
  this.targetElements[0].scrollIntoView({ behavior: "smooth", block: "center" })
}
```

```ruby
# app/helpers/turbo_stream_actions_helper.rb
module TurboStreamActionsHelper
  def scroll_into_view(id, **opts) = turbo_stream_action_tag(:scroll_into_view, target: id, **opts)
end
Turbo::Streams::TagBuilder.prepend TurboStreamActionsHelper
```

Now `turbo_stream.scroll_into_view(dom_id(@post))` works from controllers and `.turbo_stream.erb`.
`refs/writebook/app/javascript/actions/scroll_into_view.js`,
`refs/writebook/app/helpers/turbo_stream_actions_helper.rb`.

## Rich inputs as Web Components

A markdown/rich editor is a **form-associated custom element** (`attachInternals()` +
`setFormValue`) that submits like a native field inside a plain Rails form — not a Stimulus
controller and not a JS-framework island. Stimulus stays out of it.
`refs/writebook/` (`house` editor), `refs/fizzy/` (lexxy).
