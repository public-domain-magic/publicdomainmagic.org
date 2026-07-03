# Applying FRBR/WEMI to magic (conjuring) materials

Read this when cataloging magic: tricks, routines, effects, props, performances, magic
books, lecture notes, periodicals, DVDs, downloads. Magic looks chaotic bibliographically
— the same material recurs as book chapter, filmed performance, filmed explanation,
supercut, bundle, and reprint — but it maps onto FRBR cleanly once one insight is fixed:

**Model magic the way FRBR models music.** The routine is the work (like a musical work);
the written description is one expression (like the score); each performance is another
expression (like a recorded performance); products are manifestations. Everything below
follows from that.

## Guaranteed mappings

These hold always; treat them as invariants.

| Magic term | FRBR mapping |
|---|---|
| **Effect as plot/genre** (Ambitious Card, Cups and Balls, Linking Rings) | Group 3 **Concept** — a subject that works are *about*. Never a Work: it has no author, no fixed content, and no progenitor. |
| **Trick / routine** (a specific creator's: Regal's Tenacious Climber, Vernon's cups and balls) | **Work** — a distinct intellectual creation combining effect, method, and presentation. |
| **Method / handling** | Intellectual content *inside* the work, not a WEMI entity. A substantially different method or presentation for the same effect = a **different Work** (each handling is independent creative effort). |
| **Sleight / technique**, published and named | Its own (often component) **Work**; routines that employ it cite it, they don't contain it. |
| **Write-up** (book chapter, lecture-notes entry, instruction sheet) | **Expression** of the routine-work (textual form). |
| **Performance** (live capture, TV clip, DVD first half) | **Expression** of the routine-work — each distinct performance is a distinct expression. |
| **Explanation / teaching segment** | **Expression** of the routine-work, *separate from* the performance expression even when packaged together. |
| **Standalone patter script** | Its own **Work**, related to routine-works by **complement** — the same slot FRBR gives a libretto. Patter as spoken in a performance is just part of that performance expression. |
| **Book, DVD, download compiling tricks** | Aggregate **Manifestation** embodying many expressions, plus an **aggregating Work** for the curation (describe it when the curation is significant — a named, edited compilation — not for trivial complete reprints). |
| **Edition, printing, reissue; VHS → DVD → download; file format** | **Manifestation** distinctions over unchanged expressions. Each encoding format is its own manifestation. |
| **Volume splits, disc divisions, bundles, samplers, supercuts** | Manifestation-level packaging. Same expressions, new aggregate manifestations — unless footage was re-edited, which derives new expressions (abridgement/revision). |
| **A copy** (a binder of lessons, a 1584 quarto, a pressed disc, the downloaded file as used) | **Item**. |
| **Magic periodical** (Genii, The Magic Wand) | Serial **Work** (intended termination: indefinite); issues are dependent parts *and* aggregate manifestations. |
| **A column** (The Vernon Touch) | A series of component **Works**, one per installment (independent parts of their issues), optionally grouped as a small serial work. |
| **Marketed trick with prop/gimmick** | A manifestation comprising instructions + manufactured object(s); each boxed unit is an item (items may comprise several physical objects). The gimmick's *design* can itself be a work. |
| **"Created by / handling by / written by / performed by / published by"** | Group 2 **role relationships**: created → Work; handling → the (new) Work; wrote/taught/performed → Expression; published/produced → Manifestation. Never fields on the records. |

## Terms that do NOT map one-to-one — apply the ladder

- **"Effect" is ambiguous in magicians' usage.** When it names a plot anyone can build on
  ("an ambitious card effect"), it's the Concept. When it names a specific marketed
  creation ("Regal's effect from that DVD"), it's the trick = Work. Disambiguating test:
  *could two magicians independently publish their own version of this under their own
  names?* Yes → Concept; no → Work.
- **New patter/presentation on an existing trick.** Light re-dressing = a new expression
  (revision); a genuinely new premise that transforms the piece = a new work related by
  adaptation. Presentation is core creative substance in magic — do not assume patter
  changes are cosmetic.
- **Method tweaks.** Touch-ups and refinements = revision (new expression); replacing
  the method = new work. The line is the ladder's "significant independent intellectual
  effort."
- **A re-performance by someone else.** The performer realizes an expression of the
  original work only if performing *that routine*; the moment they rework method or
  presentation materially, it's their own work with a derivation edge. Decide per case,
  or set a convention per series and record it.

## Relational glue for a tradition

An effect-Concept plus sparse derivation edges is how a whole plot's literature hangs
together: every work about the cups and balls gets *has-as-subject* → Concept "Cups and
balls" (this alone collocates Scot's 1584 passage, the *Magician's Own Book* description,
Vernon's routine, and a modern video course). Work-to-work **adaptation/imitation** edges
are added *only where lineage is documented* — magic's crediting culture ("based on",
"inspired by") supplies evidence, but independent reinvention is rampant, so a
relationship needs identified works at both ends, never vibes. There is no superwork for
a tradition: bibliographic families require a common progenitor, and folk plots have
none.

## Worked patterns (compressed case law)

- **Performance + explanation reused across products** (a routine on the magician's own
  DVD, then in a themed compilation): the filmed performance and filmed explanation are
  two expressions of the trick-work; each product is an aggregate manifestation; the
  compilation embodies *the same* expressions — the expression↔manifestation many-to-many
  doing its job. Re-edited for the compilation → derived expressions.
- **Course revised, then reorganized by a new publisher** (mail-order lessons →
  hardcover volumes): each revision cycle of a lesson = new expression of the same
  lesson-work; the reorganization into volumes = new aggregating works + manifestations,
  *not* new underlying works. **Separate copyrightability proves nothing** — new
  expressions earn copyright too; run the ladder on content, not on ©.
- **Column collected into a book** (episodic writings → hardbound collection): the
  installments are the works; the book adds no expressions if texts are unaltered — one
  new aggregate manifestation + a real aggregating work (selection, foreword, index as
  augmentations).
- **A monograph serialized in a magazine** (the reverse: one work in installments):
  the installments are dependent *segmental parts* of one expression, embodied piecewise
  across issue manifestations; the later one-volume book embodies the whole expression at
  once. A print run of four copies is still a manifestation — scale is irrelevant.
- **A centuries-old classic and its afterlife** (early editions, facsimiles, modernized
  texts, transcription sites, new fine editions): one work; the expression tree forks on
  content (original spelling vs each modernization — wholesale modernization is far past
  "minor corrections"); facsimiles and each digital encoding (.html/.epub/.txt/.pdf of
  one transcription) are manifestations; surviving early copies are items where
  fingerprint/provenance/condition attributes earn their keep.
- **Broadcast clip as a DVD bonus feature**: the clip's expression re-embodied in an
  augmentation aggregate alongside the primary program — a non-integral supplement,
  exactly like a foreword in a book.

## Magic-specific gotchas

- **Performance and explanation are always two expressions**, even when sold as halves
  of one video. Users select between them ("I want to *learn* it") — that is
  expression-level selection.
- **Packaging is the most volatile layer and the least meaningful.** Volume numbering,
  disc splits, and bundle boundaries routinely vanish in re-releases (two DVDs → one zip
  of undifferentiated chapter files). Anything modeled above manifestation level because
  of packaging will break; chapters/tricks belong to works and expressions, volumes to
  manifestations.
- **Rights status is orthogonal.** "Public domain" explains *why* a work's manifestation
  count explodes; it changes nothing in the mapping.
- **Unpublished-but-famous routines** (known by reputation, never written up or filmed)
  are the contested works-without-expressions case: representable, but mark them
  exceptional and expect the record to hang on relationships and subjects alone.
- **One person, many roles.** A single figure may create the works, write the book text,
  perform on the videos, and co-own the publisher — magic's small world makes role-typed
  Group 2 relationships (not bylines) non-negotiable. Stage names and pseudonyms are
  pervasive; classic FRBR handles them as name headings, and IFLA LRM's Nomen entity is
  the formal upgrade if name-vs-person matters to your catalog.
