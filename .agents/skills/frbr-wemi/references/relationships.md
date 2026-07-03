# Relationship taxonomy

Source: IFLA *FRBR Final Report* ch. 5 (pp. 55–78), tables 5.1–5.5; Tillett's
equivalent/derivative/descriptive continuum.

## The continuum (orientation)

Content relationships run on a continuum from the original:

- **Equivalent** — same intellectual content, same mode of expression: exact copies,
  reprints, facsimiles, microfilms, simultaneous publications. These are manifestation-
  level siblings of one expression.
- **Derivative** — new expressions and, past "the cataloging rules cut-off point," new
  works: translations, revisions, abridgements, arrangements (same work) → adaptations,
  dramatizations, parodies, changes of genre (new work).
- **Descriptive** — new works *about* the original: reviews, criticism, commentary,
  annotated editions, casebooks. Always a new work, linked by subject.

## Referential vs. autonomous

- **Referential** works have little value outside the context of the related work: index,
  concordance, supplement, teacher's guide, gloss, cadenza, libretto. Surface the linked
  work prominently; a referential work's record is nearly meaningless alone.
- **Autonomous** works stand on their own: sequel, adaptation, parody, incidental music.
  The link enriches but is not required for sense.

## Work → Work (table 5.1)

| Type | Examples (referential) | Examples (autonomous) |
|---|---|---|
| Successor | sequel that directly continues | sequel, succeeding work |
| Supplement | index, concordance, teacher's guide, gloss, appendix | supplement, appendix |
| Complement | cadenza, libretto, choreography, ending for unfinished work | incidental music, musical setting for a text, pendant |
| Summarization | — | digest, abstract |
| Adaptation | — | adaptation, paraphrase, free translation, variation (music), harmonization |
| Transformation | — | dramatization, novelization, versification, screenplay |
| Imitation | — | parody, imitation, travesty |

## Expression → Expression

**Between expressions of the same work** (table 5.3) — one expression derived from
another without becoming a new work:

| Type | Examples |
|---|---|
| Abridgement | abridgement, condensation, expurgation |
| Revision | revised edition, enlarged edition, state (graphic) |
| Translation | literal translation, transcription (music) |
| Arrangement | arrangement (music) |

**Between expressions of different works** (table 5.4): the same seven types as
work-to-work (successor … imitation), used when the specific source expression is known —
e.g. *this* translation was adapted from *that* revised edition.

## Manifestation → Manifestation

| Type | Examples |
|---|---|
| Reproduction | reprint, facsimile, photo-offset reprint, micro/macroreproduction |
| Alternate | simultaneous editions by different publishers, alternate formats issued together |

Reciprocals: "has a reproduction" / "is a reproduction of". A facsimile of the 1584
*Discoverie of Witchcraft* is a new manifestation of the same expression, related by
reproduction to the manifestation it reproduces (when that source manifestation is
known — otherwise attach at expression level).

Manifestation → Item: reproduction also applies (a scan made from one specific copy);
item → item: reproduction and bound-with.

## Whole / Part (tables 5.2, 5.5)

- **Dependent parts** need the whole's context: chapters, sections, tables of contents,
  a serial's volumes/issues, illustrations for a text, the sound track of a film. Often
  no distinctive title.
- **Independent parts** stand alone: a monograph in a series, a journal article, one work
  in an anthology.
- **Segmental** parts are discrete slices (chapters, prefaces); **systemic** parts are
  interwoven aspects (illustration program, cinematography). Segmental parts are worth
  separate records far more often than systemic ones.

Part-to-part: **sequential** (issue follows issue) and **accompanying/companion**
(dependent or independent), which drives how many records to make.

## Operational rules

- A relationship is only **operative** when both ends are identified entities. "Based on
  a play by Henrik Ibsen" states nothing the system can use; "based on *Ghosts*" does.
- When the precise lower level is unknown, state the relationship at the more general
  level: if you can't establish *which edition* an adaptation used, link work-to-work and
  stop.
- Model these as a self-referential join with a closed `relationship_type` vocabulary
  drawn from the tables above, plus direction. Do not free-text relationship types.
