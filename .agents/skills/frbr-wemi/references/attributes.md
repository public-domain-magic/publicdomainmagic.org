# FRBR attributes per entity

Source: IFLA *FRBR Final Report* ch. 4 (pp. 31–52). Trimmed to attributes plausible for
this catalog (books, periodicals, ephemera, images, and possibly recordings of magic);
cartographic/remote-sensing attributes omitted. Attributes marked ♪ apply to musical
material only.

Consult this list when adding columns to `catalog_*` tables. If a proposed column is not
on the target entity's list, either it belongs at another level, it is a relationship
(creators! subjects!), or it is app-specific metadata that should be named so it can't be
confused with bibliographic data.

## Work

- title of the work (the conventional/uniform title that names the work across all
  expressions)
- form of work (novel, treatise, play, poem, essay, biography, periodical, photograph…)
- date of the work (year originally created; may be a range)
- other distinguishing characteristic (disambiguates same-titled works)
- intended termination (finite vs. intended to continue indefinitely — serials)
- intended audience
- context for the work (historical/social/artistic context of conception)
- ♪ medium of performance, numeric designation (opus/thematic number), key

Not attributes of work: author (relationship to Group 2), subject (relationship to
Group 3), language (expression), publisher (manifestation).

## Expression

- title of the expression
- form of expression (alpha-numeric notation, spoken word, musical notation, sound,
  image…)
- date of the expression
- **language**
- other distinguishing characteristic (e.g. "Gill translation", "2nd revised text")
- extensibility / revisability (is more content expected; will it be revised — serials,
  loose-leafs)
- extent of the expression (word count; duration for sound)
- summarization of content (abstract, table of contents)
- context for the expression; critical response
- use restrictions on the expression (rights-based — note: copyright *status* lives in
  the app's copyright domain, not here)
- serial: sequencing pattern, expected regularity, expected frequency
- ♪ type of score, medium of performance

## Manifestation

- title of the manifestation (transcribed from the piece — title page, label)
- statement of responsibility (as it appears on the piece)
- edition/issue designation ("2nd ed.", "revised printing")
- place of publication/distribution
- publisher/distributor
- date of publication/distribution
- fabricator/manufacturer (printer)
- series statement
- form of carrier (volume, sound cassette, videodisc, microfilm, online resource…)
- extent of the carrier (pages, sheets, discs, reels)
- physical medium (paper, vellum, plastic…)
- capture mode (analog, digital, acoustic…)
- dimensions of the carrier
- manifestation identifier (ISBN, publisher's number)
- source for acquisition / access authorization
- terms of availability; access restrictions on the manifestation
- printed book: typeface, type size; hand-printed book: foliation, collation
- serial: publication status, numbering
- ♪ sound recording: playing speed, groove width, kind of cutting, tape configuration,
  kind of sound (mono/stereo), special reproduction characteristics
- electronic: system requirements, file characteristics, mode of access, access address

## Item

- item identifier (barcode, accession number, shelf mark)
- fingerprint (early printed books: character groups transcribed from set pages to
  distinguish copies)
- provenance (chain of ownership — high value for antiquarian magic books)
- marks/inscriptions (signatures, annotations, bookplates)
- exhibition history
- condition (variances between this copy and its manifestation: missing pages, rebinding)
- treatment history; scheduled treatment (conservation)
- access restrictions on the item
- location (holding/shelving — FRBR treats this via the holding relationship, but a
  column or association here is the practical form)

## Placement heuristics

- If the fact would be identical for every copy you could buy of "the same book," it is
  manifestation-level or higher; if it varies copy to copy, item-level.
- If the fact survives a change of publisher/format (content-borne), it is expression-
  level or higher; if translation would change it, it is expression-level, not work-level.
- If the fact is about a person's role, it is a relationship, not a column.
- "Title" and "date" recur at every level as *different facts*; name columns so the level
  is unambiguous (the model namespaces already help).
