# Grouping records into works (OCLC Work-Set Algorithm, adapted)

Source: Hickey & Toves, *FRBR Work-Set Algorithm v2.0* (OCLC Research, 2009). Battle-
tested on 138M WorldCat records. Use when importing external bibliographic data (MARC,
scraped catalogs, dealer lists) or deduplicating manifestations into works.

## Two hard-won limits — respect them

1. **Works only.** OCLC found existing bibliographic records *insufficient to reliably
   divide a work into expressions* and abandoned that line. Cluster imports to works
   automatically; assign expressions by human curation (or human-confirmed heuristics
   like explicit language/edition statements).
2. **It overclusters.** The algorithm ignores format, so its sets are sometimes broader
   than a FRBR work. Treat its output as candidate groupings for review, not truth.

## The key

Generate one normalized key per incoming record; records sharing a key form a work-set.
Precedence (WorldCat frequencies shown for expectation-setting):

1. `author/title` — when a principal author exists (70.65% of records)
2. `uniform-title` — a solitary uniform/conventional title, no author needed (1.13%)
3. `title/name…` — no principal author; append other associated names (19.16%)
4. `title/record-id` — title only; forcing uniqueness because titles alone cannot be
   safely merged (9.06%)

## Normalization (NACO-style; the important parts)

- Lowercase; strip diacritics, punctuation, and leading articles ("the", "an", "la",
  "der", "le", "das", "les", "de", "el", "die"…).
- Skip non-filing characters; drop bracketed insertions unless the whole field is
  bracketed.
- Personal names: `surname, forename\dates` with dates normalized (`1835 1910`); repair
  names ending in bare digits by treating them as dates.
- Build both a *short title* (main title only) and *full title* (with subtitle); try
  matching short first.
- **Noise titles** — generic titles that must not merge across authors: "works",
  "selections", "essays", "poems", "correspondence", "speeches", "plays", "short
  stories", "songs", "laws etc"… Extend the list with your domain's generic titles. A
  record whose only title is noise falls through to the next key pattern.

## Variant reconciliation (the mapping files)

Before keying, map variant author and title headings to a preferred form using an
authority list (OCLC used LCNAF 400→100 cross-references, author/title 400s, uniform-
title 430s; also name-minus-dates aliases when unambiguous). The practical equivalent
without LCNAF: a variant-headings mapping of seen forms → canonical person/work, grown as
imports are reviewed. This mapping step is what makes the whole thing work — without it,
"Twain, Mark" vs. "Clemens, Samuel" style variants fragment work-sets.

Title-edit ladder when a lookup misses (try each, re-look-up after each): cleaned title →
strip leading articles → strip author-name prefix from title ("Johan Smith's The Ultimate
Guide…" → "The Ultimate Guide…") → strip articles again; short title first, then full.

## Grouping title/name keys (pattern 3)

Group by title first, then merge records whose name sets intersect: record 1 {smith, doe}
and record 2 {doe, jones} merge; record 3 {jones} joins through record 2; {harvey} stays
separate. Union-find over (title, name) pairs implements this directly.

## Implementation notes

- Store the computed key on the import/staging record, not on the work itself; the key
  identifies a candidate cluster, a curator confirms the Work.
- Titles with long publication histories frequently reappear under variant titles and
  pseudonymous or variantly styled authors — expect heavy reliance on the mapping table,
  and prefer one uniform (conventional) title per famous work regardless of cover-title
  variants.
- Idempotency: re-running the keyer over already-linked records must not move confirmed
  works; only unconfirmed candidates re-cluster.
