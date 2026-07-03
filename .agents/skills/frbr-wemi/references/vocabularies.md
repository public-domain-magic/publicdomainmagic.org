# Vocabulary and naming conventions (FRBR Core, openWEMI, FaBiO)

Use when naming public-facing API fields, JSON exports, or linked-data/RDF output so the
data speaks the same language as the rest of the bibliographic web. Internal application
naming need not change.

## Canonical relationship names

The classic FRBR chain, as named in FRBR Core (Davis & Newman, 2005;
`http://purl.org/vocab/frbr/core#`) — the de facto RDF vocabulary:

| Chain step | Property (forward / inverse) |
|---|---|
| Work → Expression | `realization` / `realizationOf` |
| Expression → Manifestation | `embodiment` / `embodimentOf` |
| Manifestation → Item | `exemplar` / `exemplarOf` |

Prose verbs from the FRBR report: a work *is realized through* an expression, which *is
embodied in* a manifestation, which *is exemplified by* an item.

Derivative/related properties available in FRBR Core and the SPAR `frbr.owl`
(Ciccarese & Peroni): `translation`, `revision`, `adaptation`, `arrangement`,
`abridgement`, `imitation`, `reproduction`, `successor`, `supplement`, `complement`,
`summarization`, `transformation`, `part`/`partOf`. Group 2 links: `creator` (work),
`realizer` (expression), `producer` (manifestation), `owner` (item).

## openWEMI (DCMI, 2024) — when looser coupling is wanted

Namespace `https://ns.dublincore.org/openwemi/`. Deliberately drops FRBR's disjointness
and bibliographic wording; classes are `Endeavor` ⊃ `Work`, `Expression`,
`Manifestation`, `Item` with broad definitions ("Work: an abstract notion of an
Endeavor").

- Chain properties: `expresses`/`expressedBy`, `manifests`/`manifestedBy` (range Work
  *or* Expression), `instantiates`/`instantiatedBy` (an Item may instantiate a Work,
  Expression, or Manifestation directly — non-linear links are allowed).
- Same-level: `relatedWork`, `relatedExpression`, `relatedManifestation`, `relatedItem`.
- Cross-dataset alignment without class commitments: `commonWork`, `commonExpression`,
  `commonManifestation`, `commonItem`, `commonEndeavor` — e.g. link a catalog record to a
  Wikidata/MusicBrainz work it shares.
- Intended usage: subclass for the domain (`MusicWork rdfs:subClassOf openwemi:Work`)
  and subproperty the links, rather than using the bare classes.

Prefer openWEMI names for any *external* linking feature (pointing at other sites'
records), since it makes no claims the other data can't support.

## FaBiO (SPAR ontologies) — precedent for domain subclassing

`http://purl.org/spar/fabio/`. Applies WEMI to publishing by subclassing each level:
`fabio:ResearchPaper` (Work) → `fabio:JournalArticle` (Expression) → `fabio:PrintObject`/
`fabio:DigitalManifestation` (Manifestation), with `fabio:Journal` → `JournalVolume` →
`JournalIssue` as whole/part chains at the appropriate levels. It also adds level-jumping
shortcuts FRBR lacks: `fabio:hasManifestation` (Work→M), `fabio:hasPortrayal` (Work→I),
`fabio:hasRepresentation` (Expression→I).

Lessons to copy: give users domain nouns (Treatise, Pamphlet, Periodical, Poster) as
subtypes of the WEMI levels rather than exposing raw Work/Expression; pair with Dublin
Core (`dcterms:title`, `dcterms:creator`, `dcterms:publisher`) and PRISM
(`prism:doi`-style identifiers) for garden-variety metadata instead of inventing fields.

## Quick JSON-LD sketch for an export

```json
{
  "@context": {
    "frbr": "http://purl.org/vocab/frbr/core#",
    "dcterms": "http://purl.org/dc/terms/",
    "openwemi": "https://ns.dublincore.org/openwemi/"
  },
  "@id": "/works/war-and-peace",
  "@type": "frbr:Work",
  "dcterms:title": "War and Peace",
  "frbr:realization": [
    { "@id": "/expressions/…", "@type": "frbr:Expression",
      "dcterms:language": "en",
      "frbr:embodiment": [
        { "@id": "/manifestations/…", "@type": "frbr:Manifestation",
          "dcterms:publisher": "…", "frbr:exemplar": [ { "@id": "/items/…" } ] }
      ] }
  ],
  "openwemi:commonWork": { "@id": "https://www.wikidata.org/entity/…" }
}
```
