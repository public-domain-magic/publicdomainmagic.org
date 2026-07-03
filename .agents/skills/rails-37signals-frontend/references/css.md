# CSS & assets (depth)

Plain hand-written CSS over **Propshaft** — no Tailwind/Sass/PostCSS, no Node, no build step. Modern
native CSS does the work a framework or preprocessor used to.

## Propshaft, glob-loaded, no manifest

Files are served byte-for-byte and digested; Propshaft only fingerprints and rewrites `url()`. There
is no `@import` assembly and no manifest. **Stylesheets are auto-collected by a glob — one `<link>`
per file, so dropping a new `feature.css` in ships it with no registration.** Only the spelling
varies: `stylesheet_link_tag :all` (campfire, writebook), `:app` (fizzy — app assets only, where
`:all` would also include gem assets), or a custom glob helper (engines like upright). Reference
images with plain relative `url()` — Propshaft rewrites to the digested path. `refs/fizzy/app/assets/stylesheets/`,
`refs/writebook/app/assets/stylesheets/`.

## `@layer` governs the cascade (this is what makes glob-loading safe)

Because files load alphabetically, file order can't control specificity. Declare the layer order
once and wrap every file's rules in its layer:

```css
/* _global.css (underscore sorts first, so the order is set before anything else loads) */
@layer reset, base, components, utilities, platform;

/* buttons.css */  @layer components { .btn { /* … */ } }
/* reset.css   */  @layer reset      { /* … */ }
```

Later layers always win regardless of selector specificity or load order. This is the load-bearing
decision; without it the glob would be chaos. `refs/fizzy/app/assets/stylesheets/_global.css`,
`refs/upright/app/assets/stylesheets/upright/_global.css`.

## Two-tier OKLCH tokens; dark mode flips the channels

Store colors as raw OKLCH channel triples, then wrap them in semantic vars. Dark mode (and any
theme) redefines **only the raw channels**; every semantic token follows automatically — so there's
no second dark stylesheet and no `.dark` class scattered across components.

```css
:root {
  --lch-bg:   100% 0 0;                 /* raw channels, no color function */
  --color-bg: oklch(var(--lch-bg));     /* semantic, wraps the channels */
}
@media (prefers-color-scheme: dark) {
  :root { --lch-bg: 20% 0.02 250; }     /* only the channels change; --color-bg inherits */
}
html[data-theme="dark"] { --lch-bg: 20% 0.02 250; }   /* explicit choice wins; set pre-paint to avoid flash */
```

Components reference only semantic tokens. Storing the inner triple (not a full `oklch(...)`) lets
you reuse it with alpha: `oklch(var(--lch-ink) / 5%)`. Keep `--color-always-black/white` escape
hatches for things (shadows) that must not invert. `refs/writebook/app/assets/stylesheets/colors.css`,
`refs/fizzy/app/assets/stylesheets/_global.css`.

## BEM components + a small semantic utility layer

```css
.post  .post__title  .post__title--pinned        /* BEM components */
.flex  .flex-column  .gap  .pad-block  .txt-small /* hand-rolled semantic utilities, off tokens */
```

So a real element reads `class="post__form flex align-center gap"`: one BEM hook for the component,
utilities for layout. Utilities are scoped to what the app actually uses (dozens, not a framework's
thousands) and logical-property-first (`margin-inline`, `inline-size`, `inset`) for RTL/i18n.

## Component-local custom properties = the component's public API

A component declares `var(--knob, default)` for every themeable value; variants and states **set the
property** instead of re-declaring rules.

```css
.btn        { background: var(--btn-bg, var(--color-canvas)); padding: var(--btn-pad, .5em 1.1em); }
.btn--danger{ --btn-bg: var(--color-danger); }            /* theming a variant = setting a variable */
```

## Icons & fonts

One clean icon technique (fizzy): **CSS-masked monochrome SVGs** — a `.icon` base masks a per-icon
SVG painted with `currentColor`, so icons inherit text color and theme for free (no icon font, no
inline `<svg>`, no sprite). Prefer a **system font stack** (zero web-font downloads; any `@font-face`
aliases a `local()` system font). `refs/fizzy/app/assets/stylesheets/icons.css`.

## Runtime/per-viewer CSS

Per-account or per-user styling that can't ship in a file is injected as a small `<style>` tag at
request time (e.g. a rule keyed on `Current.user.id` to hide elements flagged for that viewer), so
the same cached/broadcast HTML serves everyone. `refs/writebook/app/helpers/application_helper.rb`,
`refs/fizzy/app/views/layouts/shared/_user_css.html.erb`.
