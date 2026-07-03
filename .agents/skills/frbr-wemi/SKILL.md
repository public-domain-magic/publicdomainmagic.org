---
name: frbr-wemi
description: >
  Use when modeling or reasoning about bibliographic data with the FRBR WEMI entities —
  Work, Expression, Manifestation, Item. Trigger for: deciding whether something is a new
  work, expression, manifestation, or just another item (translations, revised/annotated/
  illustrated editions, reprints, facsimiles, adaptations, digital scans, PDF vs ePub);
  deciding which level an attribute or relationship belongs on (language, publisher,
  title, condition, creator); modeling authors/contributors, anthologies and other
  aggregates, series, or work-to-work relationships; grouping or deduplicating
  bibliographic records into works. Applies whenever the user says "edition," "printing,"
  "version," "copy," "translation," or "reissue" about bibliographic or catalog data,
  even without mentioning FRBR or WEMI. Do NOT use for copyright status determination or
  for non-bibliographic versioning (software releases, document revision control).
---

# FRBR (WEMI): modeling the bibliographic universe

FRBR's Group 1 entities model every bibliographic resource as four linked levels:

> **Work** *is realized through* **Expression** *is embodied in* **Manifestation** *is exemplified by* **Item**

- **Work** — the distinct intellectual/artistic creation. Abstract; exists only in the
  commonality of content among its expressions. Tolstoy's *War and Peace* as a creation,
  behind all its versions.
- **Expression** — one realization of the work: the specific words, sentences, and
  paragraphs (or sounds, images, notation). Excludes physical form. The original Russian
  text is one expression; the Maude English translation is another.
- **Manifestation** — one physical/digital embodiment of an expression: all copies
  sharing the same content *and* production form. A given publisher's 1943 edition is
  one manifestation; a PDF scan of it is another.
- **Item** — a single exemplar of a manifestation. The copy in hand, with its own
  condition, provenance, and marginalia.

Only the Item is concrete. Each higher level is an abstraction over the set below it: a
work is (in effect) a set of expressions, an expression a set of manifestations. Group 2
entities (persons, corporate bodies) attach through role relationships — *created* →
Work, *realized* → Expression, *produced* → Manifestation, *owned* → Item. Group 3
entities (concepts, objects, events, places, and any Group 1/2 entity) are subjects of
works. The point of the whole model is the four user tasks: **find, identify, select,
obtain**.

However you implement it (relational, document, RDF), keep the chain strict and linear
downward: an expression realizes exactly one work; an item exemplifies exactly one
manifestation. The expression↔manifestation link is many-to-many — that is where
aggregates live (see below).

This skill teaches classic FRBR (IFLA 1998, amended 2009), the vocabulary nearly all
tooling and literature use. Its successor, IFLA LRM (2017), consolidates FRBR/FRAD/FRSAD:
WEMI survives intact, but Group 2/3 are reorganized (Agent, Nomen, Place, Time-span, and
a top-level Res), and LRM formally adopts the aggregates model described below. If a task
targets LRM or current RDA, say so and flag the differences rather than silently mixing
models.

## The boundary decision procedure

When asked "is X a new work / expression / manifestation, or the same one?", walk down
this ladder and stop at the first match:

1. **Substantial independent creative effort on the content?** → **new Work** (related to
   the old one). This includes: adaptations (for children, to another medium or genre),
   dramatizations, novelizations, parodies, paraphrases and rewritings, abstracts/digests/
   summaries, annotated and commentary editions, reviews and criticism. *The Annotated
   Alice* is a new work related to Carroll's original, not an edition of it.
2. **Any change to the intellectual content itself?** → **new Expression, same Work**:
   translations, revised/enlarged/updated editions, abridgements and expurgations,
   modernized-spelling editions, a recorded reading of a text (change of form),
   arrangements and distinct performances of music. Minor corrections of spelling and
   punctuation do *not* cross this line — same expression.
3. **Change in production/physical form only?** → **new Manifestation, same Expression**:
   different publisher (even with no other visible change), reprint by a new house,
   facsimile, paper → microfilm → digital scan, PDF vs ePub vs print (each encoding format
   is its own manifestation), typeface/page-layout changes fixed at production, hardcover
   vs paperback.
4. **Differences only between individual copies, arising after production?** → same
   Manifestation; the differences live on the **Item** (damage, rebinding, inscriptions,
   provenance, missing pages).

Two refinements for digital documents:

- Post-production rendering is not a manifestation boundary. An ePub reflowing on a phone
  or a reader changing the font does not create new manifestations; the publisher's
  production plan anticipates it.
- Treat an item functionally: the thing the user actually reads, views, or hears (the
  displayed/printed copy, the played recording), not the bytes or the server. Files and
  bitstreams are means of delivery.

For contested or unusual calls — serials, music, born-digital, "is this printing a new
manifestation?" — read `references/boundary-rules.md` before answering.

## Which level does an attribute belong on?

Attributes do **not** inherit up or down the chain (see Gotchas). Put each fact at the
level FRBR assigns it:

| Level | Belongs here |
|---|---|
| Work | title of the work, form/genre, date of creation, intended audience, subjects |
| Expression | language, form of expression (text, spoken word, notation), date of the expression, revision/edition lineage, extent (word count, duration) |
| Manifestation | title as it appears on the piece, statement of responsibility, edition/issue statement, publisher, place and date of publication, series, carrier/medium, encoding format, extent (pages, discs), dimensions, identifiers (ISBN), terms of availability |
| Item | identifier/barcode, provenance, condition, marks/inscriptions, exhibition and treatment history, access restrictions, location |

Note that "title" and "date" legitimately appear at several levels because they are
different facts: the work's conventional title vs. the title printed on a specific
manifestation's title page. Name fields so the level is unambiguous. When deciding where
a new field belongs, check this table first; the full attribute lists are in
`references/attributes.md`.

## Creators and contributors

Author/creator is **a relationship, not an attribute**. Never store the author as a field
on the work record. Model a link (with a role) between Group 2 entities and the
appropriate level:

- wrote/composed/created → Work
- translated, revised, edited (the text), performed → Expression
- published, printed, manufactured → Manifestation
- owned, annotated, donated → Item

An illustrator is strictly the *creator* of the illustration works whose expressions are
aggregated alongside the text (see Aggregates); many cataloging rules simplify this to an
expression-level contributor. Either convention works — pick one and apply it
consistently.

Role vocabulary matters for the user tasks — "translated by" and "written by" must be
distinguishable, not merged into a generic byline.

## Aggregates (anthologies, collections, illustrated editions)

An **aggregate is a manifestation embodying multiple distinct expressions.** Roughly 20%
of real library holdings are aggregates, so model them deliberately. Three kinds:

- **Collections** — anthologies, collected works, journals (expressions of several works
  similar in form).
- **Augmentations** — a primary expression published with non-integral supplements:
  forewords, introductions, biographical notes, *and illustrations*. The supplements are
  expressions of their own separate works; adding them does not change the primary
  expression. An illustrated edition = the same text expression + illustration
  expressions, aggregated in one manifestation.
- **Parallels** — the same work in several languages in one volume.

Selecting and arranging an aggregate is itself creative effort producing an **aggregating
work** (realized in an aggregating expression, embodied in the aggregate manifestation).
The aggregating work is distinct from and excludes the works aggregated. This is why the
expression↔manifestation link must be many-to-many; do not force an anthology's contents
to hang off one work.

## Relationships between entities of the same level

FRBR names bidirectional relationship types; use them (or a subset) rather than a vague
"related to". Work-to-work: **successor, supplement, complement, summarization,
adaptation, transformation, imitation**, plus **whole/part** (chapters, volumes, series
members). Manifestation-to-manifestation: **reproduction** (reprint, facsimile,
microreproduction) and **alternate** (simultaneous editions). A relationship is only
operative when both sides are identified records — "based on a play by Ibsen" is not a
relationship; "based on *Ghosts*" is. When the precise lower-level source is unknown,
state the relationship at a higher level (work-to-work) rather than guessing.

Full taxonomy with referential/autonomous distinctions: `references/relationships.md` —
read it before designing a related-works feature or schema.

## Gotchas

- **No attribute inheritance.** "The item's language" is shorthand, not model. Language
  belongs to the expression; asking for it on an item means traversing item →
  manifestation → expression. Wanting an expression-level attribute directly on a
  manifestation usually signals either an aggregate (multiple expressions, multiple
  languages) or a denormalization — if you denormalize for performance, say so explicitly
  and keep the canonical field authoritative.
- **Design for 1:1:1, keep the chain anyway.** In WorldCat, 94% of works have a single
  expression and 78% a single manifestation. Creation flows should make the
  work+expression+manifestation+item fast path one step, while the model still supports
  the complex minority — which is disproportionately the famous, heavily held works.
- **Users seek expressions, not works.** Studies show users want "the English one,"
  "the illustrated one," "the latest edition" — not an undifferentiated work cluster.
  Collocate results by work, but differentiate and let users select by expression- and
  manifestation-level facets (language, form, date, carrier).
- **Expression boundaries cannot be reliably automated.** OCLC found bibliographic data
  sufficient to cluster records into *works* (author + normalized title) but abandoned
  automatic expression detection. Auto-cluster to works on import; treat expression
  assignment as curated, human-confirmed data. Algorithm: `references/work-set-algorithm.md`.
- **Changes after production belong to the item.** A rebound, damaged, or autographed copy
  is not a new manifestation. Conversely, a publisher change *alone* is a new
  manifestation even when the content and look are identical.
- **Works about works are new works.** Commentary, criticism, reviews, annotated editions
  relate to the original via subject/descriptive relationships (Group 3 permits works as
  subjects) — never as expressions of it.
- **Different printings, same publisher = same manifestation** unless changes were
  substantive or intentional (a "second printing" with corrections is a new manifestation
  embodying a possibly-new expression; check the content).
- **The model is a framework, not an algorithm.** FRBR deliberately leaves boundary
  details to cataloging rules and local user needs; communities interpret it differently
  (that is by design). When a call is genuinely ambiguous, decide by the four user tasks —
  which choice helps a user find, identify, select, and obtain — and record the decision
  consistently rather than searching for a nonexistent universal answer.

## Reference files

- `references/boundary-rules.md` — authoritative definitions, full same-vs-new lists with
  examples, digital-document and serial edge cases. Read when a boundary call is
  contested, unusual, or involves non-book material.
- `references/relationships.md` — complete relationship taxonomy (work/expression/
  manifestation levels, whole-part, referential vs autonomous). Read before building
  related-works schema or UI.
- `references/attributes.md` — full FRBR attribute lists per entity. Read when adding
  fields to bibliographic records or tables.
- `references/work-set-algorithm.md` — OCLC's work-clustering algorithm adapted from
  MARC. Read when importing external records or deduplicating into works.
- `references/vocabularies.md` — canonical property names from FRBR Core, openWEMI, and
  FaBiO. Read when naming public-facing API fields, exports, or linked-data output.
