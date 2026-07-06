# The magical arts: taxonomy & assessment research

Research compiled July 2026 (sub-agent reports) toward a future trick-level model for
the Magic bounded context. **Not built at launch** — PDM is a library, not a trick
index; launch ships flat Tags (plan 005), and this document preserves the expensive
findings for the day trick-granularity cataloging and curators exist. The migration
path is tag mining: the folksonomy accumulated by contributors seeds these vocabularies.

## Sources surveyed

- **Conjuring Archive** — its atom is the entry-in-publication with typed edges
  (Inspired by/Variations, Related to, Also published here), which map onto Catalog
  work-to-work relationships + the Embodiment M:N. Prop/theme tree; cards ≈ 46% of
  entries (CA is conjuring-only).
- **Retailers / old-book platforms** — venue + product-type + creator facets. Edition
  grouping, curated taxonomy, and copyright-status reasoning are the differentiators
  (Catalog + Copyright provide them).
- **Authoritative bodies** — FISM, S.A.M., I.B.M. all cut the field by **venue first**
  (Stage vs. Close-up); mentalism/comedy are FISM *sub-categories of Stage*, not
  co-equal top divisions. Umbrella term = "magic" (public) / "the conjuring arts"
  (scholarly; CARC's wide "and allied arts" scope). "Mystery arts" (Burger/McBride;
  PSYCRETS) is a named genre *cluster* (mentalism + bizarre + psychic + hypnosis +
  readings), not the root. Truly separate sibling umbrellas: stage hypnosis,
  ventriloquism, sideshow, juggling, balloon (the IJA split from the I.B.M. in 1947).

## Findings

### Difficulty is not a scalar

Two agents independently concluded a single universal difficulty scalar is wrong:
"self-working ↔ knuckle-buster" is a conjuring manual-dexterity axis that is native to
some arts (gambling demo, juggling), renamed & revalued in others (escapology's
gaffed↔regulation, sideshow's gaff↔real, where hard = prestigious/dangerous),
**inverted** in comedy/children's (self-working is a *virtue*), and **absent** in
hypnosis/quick-change. BUT sleight is *shared* — mentalists use center tears, billet
switches, card work (Osterlind, Maven). The durable model: **a shared ordinal scale
rated over art-scoped skill dimensions** (sleight spans conjuring/mentalism/gambling;
scripting spans mentalism/comedy/mystery), plus **universal practicality traits** (risk,
setup, reset, angles, practice, authenticity) that genuinely span every art.

### Effect taxonomies are art-scoped

Fitzkee's object-transformation verbs (production, vanish, transposition,
transformation, penetration, restoration, animation, levitation…) fit conjuring;
claimed-faculty effects (telepathy, prediction, clairvoyance, precognition,
psychokinesis, mind influence, mediumship, book test, billet reading, drawing
duplication, lie detection, memory feat, rapid calculation) fit mentalism. The two don't
map onto each other; they deliberately overlap only where the arts genuinely do (ACAAN).

### Commerciality is three orthogonal axes

None a difficulty synonym: **worker-value** (worker ↔ exhibition-piece), **fooler**
(fools laypeople ↔ fools magicians — *whom* it deceives), **reputation-maker**
(memorability). "Flash"/"pipe" are false antonyms — flash = accidental exposure.

### Presentation-stance is a fourth independent axis

For the mentalism/psychic/mystery cluster: skill-framed (mentalist) ↔ genuine-psychic
(psychic entertainer) ↔ theatrical-supernatural (mystery performer / bizarrist), plus a
disclaimer policy (the "mentalist's dilemma"). A framing axis, independent of difficulty
and effect.

## The orthogonal axes (the future design's backbone)

Every axis is independent; a trick is a point in all of them — which is why the model
decomposes rather than collapsing onto one object:

| Axis | Would be modeled as |
|---|---|
| Art / discipline | `Magic::Art` entity (conjuring, mentalism, …) |
| Venue | `Magic::Venue` (close-up, parlour, stage, street, …) — the authorities' primary cut |
| Category (prop/theme) | `Magic::Category` tree + Concept bridge |
| Effect (what appears to happen) | `Magic::Effect`, art-scoped, unique `[art, name]` |
| Skill difficulty | `Magic::SkillRating`s over art-scoped `Magic::SkillDimension`s (M:N with Art via `ArtSkillDimension` — sleight spans arts), on a shared ordinal `%w[none low moderate high extreme]` |
| Practicality | `Magic::Practicality` value object (risk, setup, reset, angles, practice, authenticity) |
| Commerciality | `Magic::Commerciality` value object (worker, fooler, reputation-maker) |
| Presentation-stance | `Magic::PresentationStance` value object (stance, disclaimer) |

## Sketched implementation (37signals idiom, if/when built)

- `Magic::Trick`: thin aggregate root, one per routine `Catalog::Work` (requires
  component-work cataloging in plan 001's whole/part machinery first). Composes the
  three value objects via `composed_of` over plain enum columns (`Data.define` POROs
  with predicate messages: `practicality.impromptu?`, `commerciality.fools_magicians?`,
  `stance.claims_real_powers?`); owns `SkillRating` children (the difficulty vector);
  references Art/Effects/Categories/Venues by join tables. Validations:
  `effects_within_art`, `skill_ratings_within_art`.
- Trick-to-trick derivation stays in Catalog work relationships (Magic delegates).
- Community sleight labels map onto the shared ordinal (self_working ≈ none/low,
  knuckle_buster ≈ extreme) — documented, not a separate scale, so cross-art queries
  work.
- Seed vocabularies from the findings above; additional arts (hypnosis, ventriloquism,
  sideshow…) are rows + art_skill_dimension links, not schema changes.

## Prerequisites before building any of this

1. Catalog cataloging at component-trick granularity (works + whole/part), in practice
   not just in schema.
2. Curators: the axes are ~a dozen judgment calls per trick; sparse or inconsistent
   ratings are worse than none in a public UI.
3. Tag mining: promote the accumulated flat tags (plan 005) into these vocabularies;
   tags with heavy use become Effects/Venues/Categories; a tag's optional Concept link
   carries over.
