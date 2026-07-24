# The librarian's cataloging workflow

How a librarian records what they find, and the domain model and context seams behind
it. Written from a working session cataloging real magic books; the worked cases at the
end are the expensive part — preserve them.

## The shape of the work: progressive enrichment

A librarian records **a fact they found**, with as little effort as possible, then adds
more if and when they learn it. This is plan 004's "failure isn't a thing — it's just
how far it goes," applied to intake:

- **A title alone creates a catalog entry.** Nothing else is required.
- Everything else is **optional enrichment**, added later on the existing entry through
  small, focused actions — and that "add later" surface is the *same* one used during
  the initial recording.
- Existing entries are **easy to surface and change** (search, then edit).
- **Never demand a fact the librarian doesn't have.** They may hold only a photo of a
  book's cover. When they have more, they give more; the system records what it's given.
- **Never invent.** An unknown fact is *absent*, never a fabricated default. Create
  component records (volumes, issues, lessons, collected titles) **only when the
  librarian enumerates or counts them** — never fill implied gaps.

The system is a **deterministic web app** — ordinary forms and small actions, following
established interaction patterns (Cooper, *About Face*; Tidwell, *Designing Interfaces*).
It does **not** parse free-text pastes with an LLM. It may derive facts deterministically
(e.g. the source from a URL host: Project Gutenberg, HathiTrust, the Library of Congress,
the Internet Archive).

## Ubiquitous language

| Term | Meaning |
|---|---|
| **Entry** | what a librarian creates and enriches — a catalog **Work** and everything hung off it |
| **Work / expression / manifestation** | FRBR/WEMI (see `.agents/skills/frbr-wemi/`). We follow FRBR's vocabulary because the trade has none of its own — "omnibus / collection / reprint / collected works / complete set / hardbound version" are used inconsistently |
| **Edition** | a **manifestation** in ordinary speech — a specific published form |
| **Reproduction** | page **images** of an existing edition (HathiTrust, LoC, IA scans). A reproduction *of* a print edition, not its own edition |
| **Transcription** | a re-keyed **text** edition (Project Gutenberg). Its *own* digital text edition |
| **Best name** | the recognizable name a Catalog author's works collocate under ("Max Maven", "Jean Hugard") — for browse |
| **Name as used** | the name printed on a given edition ("Phil Goldstein" on *Thavant*), transcribed as-is |
| **Collects / aggregate** | one manifestation gathering many works (an omnibus; a column collected into a book) |
| **Volume / issue / installment** | dependent parts of a whole (a multi-volume set; a serial's issues; a column's installments) |
| **Serial** | a periodical work, intended to continue indefinitely; issues are its parts |
| **Derivation** | one work re-realized from another (the original Tarbell mail-order course → the hardcover Course) |
| **External reference** | a third-party record *about* a work (Magicpedia, a dealer page) — evidence, not the book |
| **Copyright notice** | a ©-line transcribed from a piece (claimant, year, registration) — evidence |
| **Verdict** | the computed copyright status: **public domain**, **not public domain**, or **needs Rule 6 research** |

The umbrella is **"magic"** (public) or **"the conjuring arts"** (scholarly); the field
spans conjuring, mentalism, psychic entertainment, mystery performance, and more. The
multi-axis, per-concept categorization (venue, effect, difficulty, worker-value,
exposure-sensitivity…) is **deferred** — see `magic-taxonomy-research.md`. None of it is
an intake fact.

## Context seams (Evans; Vernon, *IDDD*)

Each bounded context has its **own model**; contexts reference one another **by identity
(ID)**, never by sharing a model. The same real-world thing is modeled differently in
each context, for that context's purpose.

### Names and identity belong to Copyright

A copyright is held by a **natural human, never a pen name** — so the authoritative
*unification* of identities is a **Copyright** concern, and it is legally load-bearing.
Phil Goldstein *is* the human behind "Max Maven" and holds the copyright to both
*Thavant* (bylined Goldstein) and *Parallax* (bylined Max Maven). Copyright also owns the
downstream legal facts: **heirs** (Rule 6 needs them), and corporate **chain of title**
(renamed / d.b.a. / acquired / dissolved-with-assets-sold / line-of-business sold…).

**Catalog keeps only a lighter, bibliographic model of the same people:**

- Each edition shows the **name as used** at the time (transcribed byline).
- A **best name** collocates an author's works for browse.

The canonical name **differs by context**, which is why these are two models and not one
shared field: Catalog's best name is **Max Maven** (recognition); Copyright's authoritative
identity is **Phil Goldstein** (the legal person). Many Catalog author-identities may map
to one Copyright person. They are linked by ID.

> Do **not** put legal identity, heirs, or chain-of-title in Catalog. Do **not** merge
> Catalog authors on a shared name string (Maskelyne *père* ≠ *fils*; Larsen Sr ≠ Jr).

### The same link, modeled twice

A real-world relationship is expressed independently in each context that cares. The
original Tarbell mail-order course and the later hardcover Course get **a Catalog FRBR
derivation link** *and* **a Copyright derivative/renewal-chain link**. Both are required
in that case; not every case needs both.

### Trusted evidence is shared

When a librarian trusts an external reference enough to record it as Copyright evidence,
they trust it enough for Catalog facts too. One trusted source feeds **both** — Catalog
bibliographic facts and Copyright citations. A review is **both** a component work
(*review-of*) and an external reference.

## FRBR levels and editions (Catalog)

- **Work** carries the uniform/short title ("Sharps and Flats"), form, date of creation.
- **Manifestation** carries the transcribed full title ("Sharps and Flats: a complete
  revelation…"), the half-title/parallel titles, publisher, place, extent, edition/issue
  statement, printing, and the access address (URL) for digital editions.
- **Printing vs edition** is drawn per FRBR in Catalog; US copyright law draws its own,
  different line in Copyright (some changes make a new copyrightable work, some don't).
- Digital: **image scans** (HathiTrust/LoC/IA) are **reproductions of** a print edition;
  a **PG transcript** is its own digital text edition. Both carry a "where to read it"
  address; the public library links out to them.
- We do **not** track items/holdings — not our copies, not other libraries' copies or
  donors. It's irrelevant to the catalog.

## Copyright verdict: compute, never demand

Transcribe ©-notices as evidence. When the librarian gives a publication year, the
Copyright context **computes what it can, by date math against today** (never a hardcoded
year):

- published **≥ 95 years ago** (`this_year − 95`, advancing every Jan 1) → **public
  domain** (term expired);
- **1978 or later** → **not public domain** (term nowhere near run);
- the **uncertain middle** (~1929–1977, where notice/renewal decides) → **needs Rule 6**.

Because the first line is arithmetic, the "needs Rule 6" band shrinks on its own over
time. Renewal/notice research, heirs, and chain of title are **Rule 6** — a separate track
(see plan 003), not intake.

## Four different things people call "authorship"

Keep these distinct; they are not one "credited vs. actual" flag:

- **Pseudonym** — one person, an alternate name. *Phil Goldstein* → *Max Maven*.
- **Close collaboration** — two real contributors working together. *Lewis Ganson* wrote
  many of *Dai Vernon*'s books **with** Vernon (who wasn't a writer), closely, to get it
  right. Not ghostwriting.
- **Ghostwriting** — credited to X, actually written by Y, concealed.
- **Uncredited rewrite / compilation** — *Jean Hugard*'s *Encyclopedia of Card Tricks*
  gathered many magicians' tricks, rewritten by Hugard, almost entirely uncredited.

## Case law (real discoveries)

Canonical cases the model must handle. Each is a lesson.

- **The Essential Dai Vernon** (L&L, "Deluxe Collector's Edition") — an **omnibus**: one
  aggregate edition collecting **eight previously-independent works** (each with its own
  prior edition). A "Deluxe" label *implies* an ordinary edition, but implication is not
  confirmation — record no ordinary edition until confirmed.

- **The Tarbell Course in Magic** — a multi-volume work (8 hardcover volumes). The
  **original was a mail-order correspondence course** (Tarbell System, Inc., Chicago; 60
  lessons); the hardcovers **republish the 60 lessons and add new material** (which
  lessons in which volume, which volumes new/mixed — unknown, a lead). The original↔book
  link is required in **both** Catalog (derivation) and Copyright (renewal chain). The
  ©-page carries a chain (1926 cover / 1927 title page / 1941, 1944, 1953 Tannen / 1971
  Robbins) — evidence, not a computed verdict. Trap: **"1926 Sunnyside Avenue" is a street
  address, not a year.**

- **Sharps and Flats** (John Nevil Maskelyne, 1894) — one work, three editions: the 1894
  Longmans print; a **HathiTrust image reproduction** of it; a **Project Gutenberg text
  transcription**. Same content, different forms → distinct manifestations, one work.

- **Our Magic** (1911) — author **Nevil Maskelyne, 1863–1924**, is the **son**; *Sharps
  and Flats*' **John Nevil Maskelyne** is the **father**. Different people despite the
  shared surname — **never merge on the name**; the dates disambiguate. Two creators
  (Maskelyne **and** David Devant). LoC digital form (512 images) = a reproduction.

- **The Art of Magic** (T. Nelson Downs, ed. John Northern Hilliard, 1909) — **publisher**
  (Arthur P. Felsman) is **not** the **copyright claimant** (Downs-Edwards Company); keep
  them separate. UK registration ("Entered at Stationers' Hall"). Edition history stated
  (Jan 1909; 2nd ed. Feb 1921) but which edition a given scan is may be unknown.

- **Genii** — **one serial work**, not many. The four issues seen (Vol 1 №1 1936 …
  Vol 49 №1 1985) are **parts**; the subtitle evolves ("Pacific Coast Magic News" →
  "The International Conjurors' Magazine") but the title *Genii* is constant, so it is one
  serial. Don't fabricate the issues in between. The **Larsen** masthead is an identity
  minefield: *William Larsen Jr.* = *Bill Larsen* (one person, two names) ≠ *William W.
  Larsen Sr.* (the father); *Geraldine Larsen-Baker* = *Geraldine Larsen Jaffe* (one
  person, remarried); the *William W. Larsen Corporation* is a body, not a person.

- **The Vernon Touch** — Dai Vernon's **column** in *Genii* (1968–1990): a **series of
  component works** (installments), parts of Genii issues. Separately, a **2006 hardcover**
  (Genii Books, under Richard Kaufman) is an **aggregate** collecting the column. Links
  three existing entries — **Dai Vernon** (also the namesake of the omnibus), **Genii**,
  **Bill Larsen** — and a **corporate succession** (Genii Corporation ← William W. Larsen
  Corporation, after Kaufman's takeover). Working title "The Cranky Old Man of Magic" is a
  title variant, not a separate work.
