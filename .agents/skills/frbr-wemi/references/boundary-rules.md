# Boundary rules: authoritative definitions and edge cases

Sources: IFLA *FRBR Final Report* (1998, amended 2009) ch. 3; O'Neill & Žumer,
"Application of the Model to Textual Documents" (2018); IFLA Working Group on Aggregates
final report (2011); Yale music cataloging guidance.

## Entity definitions (FRBR 2008)

- **Work** (§3.2.1, p. 17): "a distinct intellectual or artistic creation." Abstract —
  "the work itself exists only in the commonality of content between and among the
  various expressions of the work." Referring to Homer's *Iliad* means the creation
  behind all recitations and texts, not any one of them.
- **Expression** (§3.2.2, p. 19): "the intellectual or artistic realization of a work in
  the form of alpha-numeric, musical, or choreographic notation, sound, image, object,
  movement, etc., or any combination of such forms." For text: the specific words,
  sentences, paragraphs. Explicitly *excludes* typeface, layout, and other physical-form
  aspects not integral to the realization.
- **Manifestation** (§3.2.3, p. 21): "the physical embodiment of an expression of a
  work" — represents *all* physical objects bearing the same characteristics of both
  intellectual content and physical form. A manifestation is itself abstract (a set of
  interchangeable copies); only items are concrete.
- **Item** (§3.2.4, p. 24): "a single exemplar of a manifestation." Usually one physical
  object, but can span several (a two-volume set issued together is one item).

## New WORK — modification "involves a significant degree of independent intellectual or artistic effort" (p. 18)

- paraphrases, rewritings
- adaptations for children
- parodies, imitations, travesties
- dramatizations, novelizations, versifications, screenplays
- adaptations from one literary or art form / medium to another (book → film, book →
  video game — the result is no longer even the same document type)
- abstracts, digests, summaries
- musical variations on a theme; free transcriptions of a musical composition
- annotated editions, commentary, reviews, criticism (works *about* the work)

Report examples: Bunyan's *Pilgrim's Progress* vs. an anonymous adaptation for young
readers (two works); Shakespeare's *Romeo and Juliet* vs. Zeffirelli's and Luhrmann's
films (three works).

## New EXPRESSION, same work (pp. 19–20)

- translation (each translation, and each translation *from a different source edition*,
  is a distinct expression — for nonfiction the source is usually the latest edition, not
  the progenitor)
- revision, updating, new edition (each of *Gray's Anatomy*'s 41 editions is a distinct
  expression of one work — even through title and authorship changes, as with
  *Guide to the Library of Congress Classification* across Immroth → Chan → Intner/Weihs)
- abridgement, condensation, expurgation (content removed but not transformed)
- change of form: text → recorded reading (audiobook), speech → transcription
- music: each arrangement, transcription, and each distinct performance
- addition of parts or accompaniment to a musical composition
- dubbed or subtitled versions of a film

**Same expression:** corrections of spelling and punctuation; minor variations between
hand-press copies; reprint editions and simultaneous publications with identical content.
Rule of thumb: any change in intellectual content = new expression; no content change =
same expression.

## New MANIFESTATION, same expression (pp. 21–22)

Boundaries are drawn on both intellectual content and physical form. New manifestation
when the *production process* changes:

- display characteristics fixed at production: typeface, font size, page layout
- physical medium: paper → microfilm → digital; container: cassette → cartridge
- **each digital encoding format, including its DRM layer**: PDF, ePub, Mobi, HTML, Word,
  Braille are all distinct manifestations of the same expression
- publisher, distributor, repackaging, or publication/marketing changes signaled in the
  product — a publisher change alone creates a new manifestation
- reproductions: facsimile, reprint, photo-offset, micro/macroreproduction (same
  expression, related manifestations)

**Same manifestation:**

- variations between copies caused *after* production (damage, rebinding by a library,
  loss of pages, autographs, marginalia) — those are item-level facts
- unintentional, non-substantive manufacturing variation (worn type, different paper
  batch); different printings exemplify the same manifestation unless changes were
  substantive or intentional
- post-distribution rendering of digital documents: font-size changes, reflow, night
  mode, display size. The final appearance of a digital document is fixed at display
  time, under the reader's control, per the publisher's production plan — a strict
  reading ("any layout change = new manifestation") would absurdly make every screen size
  a new manifestation. Judge digital manifestations by what the producer fixed at
  production (the encoding), not by rendered appearance.

## Items in the digital world

FRBR calls the item "a concrete entity," which fails for digital documents (files and
in-memory states are not what anyone reads; a file may be several documents or vice
versa). O'Neill & Žumer's resolution, follow it here: identify the item **functionally —
the entity the reader or listener actually uses** (the displayed or printed copy). This
keeps analog and digital treatment consistent. LRM similarly allows digital items to vary
within a manifestation because the production plan leaves device details unspecified.

## Aggregates (Working Group on Aggregates, 2011; adopted by LRM)

An aggregate is **a manifestation embodying multiple distinct expressions**. ~20% of
library holdings. Three types:

1. **Collections** — expressions of works similar in form/genre: anthologies, selected
   and collected works, journals.
2. **Augmentations** — a primary expression plus non-integral supplements (forewords,
   introductions, illustrations, notes, biographical sketches). Supplements are
   expressions of separate works; they do not alter the primary expression.
3. **Parallels** — expressions of the *same* work (multilingual editions, bilingual
   official publications).

The act of aggregating is a distinct creative effort producing an **aggregating work**,
realized in an aggregating expression, embodied in the aggregate manifestation. The
aggregating work excludes the aggregated works. It need not be separately described
unless significant (a named anthology with an editor usually is; a bound-with usually
isn't).

Component works are also first-class: a chapter, a journal article, one trick description
within a larger treatise can be modeled as a (dependent or independent) part — see
`relationships.md` for whole/part types. Cataloging level (collection vs. work vs.
component) is a local policy decision driven by user needs; whatever the chosen "whole,"
record the whole/part links.

## Known stress cases — decide locally, document the decision

- **Serials/continuing resources.** A serial never "closes": the whole run as one
  manifestation is a set that grows forever, but issue-level records fragment the unity.
  LRM patches this with a "serial work" concept; there is no clean answer. For this
  catalog (mostly monographs and finished periodicals from the public domain era), model a
  defunct magazine as a serial work with issues as parts.
- **Music and performance genres.** Classical assumptions (composer creates the work,
  performers create expressions) fail for jazz/improvisation (the performance *is*
  substantially creative), covers, and sampling (horizontal family relationships, not
  vertical derivation). If the catalog takes on musical or performance material
  (recorded magic acts, instructional films), expect boundary calls to be genre-dependent
  and favor explicit related-work links over forcing a hierarchy.
- **A work with no surviving expression** (a documented-but-lost manuscript) is
  representable: create the work with work-to-work relationships and no expression rows,
  but treat this as exceptional.
