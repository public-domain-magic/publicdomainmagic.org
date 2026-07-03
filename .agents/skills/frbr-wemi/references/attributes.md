# FRBR attributes per entity

Source: IFLA *FRBR Final Report* ch. 4 (pp. 31–52). These are the complete attribute
lists from the report, grouped by the material types they qualify (unmarked attributes
apply to all materials). The report's lists are a floor, not a ceiling — it explicitly
allows additional attributes where user needs warrant.

Consult this list when adding fields to bibliographic records or tables. If a proposed
field is not on the target entity's list, either it belongs at another level, it is a
relationship (creators! subjects!), or it is application-specific metadata that should be
named so it can't be confused with bibliographic data.

## Work

- title of the work (the conventional/uniform title that names the work across all
  expressions)
- form of work (novel, treatise, play, poem, essay, biography, symphony, map, drawing,
  painting, photograph, motion picture…)
- date of the work (year originally created; may be a range)
- other distinguishing characteristic (disambiguates same-titled works)
- intended termination (finite vs. intended to continue indefinitely — serials)
- intended audience
- context for the work (historical/social/artistic context of conception)
- musical work: medium of performance, numeric designation (opus/thematic number), key
- cartographic work: coordinates, equinox

Not attributes of work: author (relationship to Group 2), subject (relationship to
Group 3), language (expression), publisher (manifestation).

## Expression

- title of the expression
- form of expression (alpha-numeric notation, musical notation, spoken word, musical
  sound, cartographic image, photographic image, sculpture, dance, mime…)
- date of the expression
- **language**
- other distinguishing characteristic (e.g. a named translation, "2nd revised text")
- extensibility / revisability (is more content expected; will it be revised — serials,
  loose-leafs)
- extent of the expression (word count; number of images; duration for sound/motion)
- summarization of content (abstract, table of contents, list of parts)
- context for the expression; critical response
- use restrictions on the expression (rights-based — note: copyright *status*
  determination is a separate concern from bibliographic description)
- serial: sequencing pattern, expected regularity, expected frequency
- musical notation: type of score; musical notation or recorded sound: medium of
  performance
- cartographic image/object: scale, projection, presentation technique, representation
  of relief, geodetic/grid/vertical measurement
- remote sensing image: recording technique, special characteristic
- graphic or projected image: technique (method used to create the image or realize
  motion)

## Manifestation

- title of the manifestation (transcribed from the piece — title page, label, title
  frames)
- statement of responsibility (as it appears on the piece)
- edition/issue designation ("2nd ed.", "revised printing")
- place of publication/distribution
- publisher/distributor
- date of publication/distribution
- fabricator/manufacturer (printer, pressing plant)
- series statement
- form of carrier (volume, sound cassette, videodisc, film reel, microfilm cartridge,
  transparency, online resource…)
- extent of the carrier (sheets, pages, discs, reels)
- physical medium (paper, vellum, plastic, metal…)
- capture mode (analog, digital, acoustic, electric, optical…)
- dimensions of the carrier
- manifestation identifier (ISBN, publisher's/catalog number)
- source for acquisition / access authorization
- terms of availability; access restrictions on the manifestation
- printed book: typeface, type size; hand-printed book: foliation, collation
- serial: publication status, numbering
- sound recording: playing speed, groove width, kind of cutting, tape configuration,
  kind of sound (mono/stereo), special reproduction characteristics (noise reduction,
  equalization)
- image: colour
- microform: reduction ratio
- microform or visual projection: polarity, generation
- visual projection (incl. motion pictures/video): presentation format (e.g. film
  format, broadcast/video standard)
- electronic resource: system requirements, file characteristics; remote access: mode of
  access, access address

## Item

- item identifier (barcode, accession number, shelf mark)
- fingerprint (early printed books: character groups transcribed from set pages to
  distinguish copies)
- provenance (chain of ownership — high value for rare and antiquarian materials)
- marks/inscriptions (signatures, annotations, bookplates)
- exhibition history
- condition (variances between this copy and its manifestation: missing pages, rebinding)
- treatment history; scheduled treatment (conservation)
- access restrictions on the item
- location (holding/shelving — FRBR treats this via the holding relationship, but a
  field on the item is the practical form)

## Placement heuristics

- If the fact would be identical for every copy you could buy of "the same release," it
  is manifestation-level or higher; if it varies copy to copy, item-level.
- If the fact survives a change of publisher/format (content-borne), it is expression-
  level or higher; if a translation or re-performance would change it, it is
  expression-level, not work-level.
- If the fact is about a person's role, it is a relationship, not an attribute.
- "Title" and "date" recur at every level as *different facts*; name fields so the level
  is unambiguous.
