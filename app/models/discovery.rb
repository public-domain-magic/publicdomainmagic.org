# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# The librarian's front door: recording a book they have found, with whatever
# is known, to answer two questions — *could this be public domain?* (for the
# librarian) and *does this exist?* (for everyone).
#
# An application-level use case owned by no single bounded context, so it lives
# at the top level. It coordinates the four contexts through each one's public
# API — never by reaching into another's tables — and materializes the whole
# FRBR graph in one transaction:
#
# - *Catalog* — a new +Work+; a fresh +Agent+ per author name (identity is never
#   merged on a name string — the discovery is intake, deduplication is a later
#   curated step); each found copy as an online +Manifestation+ + +Embodiment+
#   attached to an existing or new +Expression+; each cited record as an
#   +ExternalReference+.
# - *Copyright* — a +Determination+ opened +researching+; a known pre-1978 year
#   is computed to +determined+ with its public-domain countdown on the spot.
# - *Workflow* — +Project.start+ (the signed-in librarian is the lead), with the
#   +discovery+ step marked done.
# - *Magic* — a public +Listing+, so the book surfaces in the library at once.
#
# It is a form object, not a service layer: the controller calls one method,
# +#save+, and the FRBR-chain construction uses Catalog's own model API.
class Discovery
  include ActiveModel::API

  # The default expression language code at intake (the launch corpus is
  # English text; a non-English work is deepened later).
  DEFAULT_LANGUAGE_CODE = "eng"

  # The name paired with DEFAULT_LANGUAGE_CODE when the language row is created.
  DEFAULT_LANGUAGE_NAME = "English"

  # The default form of expression at intake — textual, the book case.
  DEFAULT_FORM_OF_EXPRESSION = "Text"

  # The carrier name for a digital edition found online.
  ONLINE_CARRIER = "Online resource"

  # The work being recorded.
  attr_accessor :title, :date

  # First-publication facts, when known — a pre-1978 year drives the countdown.
  attr_accessor :first_publication_year, :first_publication_country

  # The optional form of work (a +Catalog::FormOfWork+ id; blank is honest).
  attr_accessor :form_of_work_id

  # The public exposure of the resulting listing (+public+ or +protected+).
  attr_accessor :exposure

  # The librarian's private note about the discovery.
  attr_accessor :notes

  # The acting librarian; defaults to the signed-in user, like a model's
  # +Current+-defaulted owner.
  attr_writer :librarian

  # The records this discovery created, for the controller to redirect to.
  attr_reader :work, :listing, :determination

  validates :title, presence: true
  validates :exposure, inclusion: { in: Magic::Listing::EXPOSURES }
  validate :nested_records_are_valid

  # Build a discovery from form params. Author names, found copies, and cited
  # references arrive as nested collections; scalars default to the launch case.
  def initialize(attributes = {})
    @author_names = []
    @found_copies = []
    @external_references = []
    @exposure = "public"
    assign_attributes(attributes) if attributes.present?
  end

  # The acting librarian, defaulting to the signed-in user.
  def librarian
    @librarian || Current.user
  end

  # Author names entered on the form; blanks are dropped.
  attr_reader :author_names

  # Assign author names from the form's repeatable inputs, dropping blanks.
  def author_names=(values)
    list = Array(values) #: Array[untyped]
    @author_names = list.map { |value| value.to_s.strip }.compact_blank
  end

  # The found copies (nested rows); wholly blank rows are dropped, so the form's
  # empty starter rows never become degenerate editions.
  attr_reader :found_copies

  # Assign the found-copy rows from the form's nested attributes.
  def found_copies_attributes=(rows)
    @found_copies = build_rows(rows, Discovery::FoundCopy)
  end

  # The cited third-party records (nested rows); wholly blank rows are dropped.
  attr_reader :external_references

  # Assign the cited-record rows from the form's nested attributes.
  def external_references_attributes=(rows)
    @external_references = build_rows(rows, Discovery::ExternalReference)
  end

  # Seed the +new+ form with blank rows to fill in (the rejecting setters drop
  # any left empty on submit).
  def prefill(found: 3, references: 2)
    found.times { @found_copies << Discovery::FoundCopy.new }
    references.times { @external_references << Discovery::ExternalReference.new }
    self
  end

  # Materialize the whole graph in one transaction. Returns +true+ on success;
  # on failure the transaction rolls back and +false+ is returned with errors.
  def save
    return false unless valid?

    actor = librarian
    if actor.nil?
      errors.add(:base, "A librarian must be signed in to record a discovery.")
      return false
    end

    ActiveRecord::Base.transaction do
      work = build_catalog
      open_determination(work)
      start_workflow(work, actor)
      publish_listing(work)
    end
    true
  rescue ActiveRecord::RecordInvalid => error
    errors.add(:base, error.message)
    false
  end

  private def nested_records_are_valid
    (found_copies + external_references).each do |row|
      errors.add(:base, "Every found copy and cited record needs a URL.") unless row.valid?
    end
  end

  # Accept either an Array of attribute hashes or the index-keyed Hash that
  # +fields_for+ posts, dropping wholly blank rows.
  private def build_rows(rows, klass)
    list = rows.is_a?(Hash) ? rows.values : Array(rows)
    list.filter_map do |attributes|
      next if attributes.to_h.values.all?(&:blank?)

      klass.new(attributes)
    end
  end

  private def build_catalog
    @work = Catalog::Work.create!(title:, date: date.presence, form_of_work:).tap do |work|
      create_authors(work)
      create_found_copies(work)
      create_external_references(work)
    end
  end

  private def form_of_work
    Catalog::FormOfWork.find_by(id: form_of_work_id) if form_of_work_id.present?
  end

  # A fresh Agent per name — never merged on a name string (one person may
  # hold many names, one name many people); merging is a later curated step.
  private def create_authors(work)
    author_names.each do |name|
      work.contributions.create!(agent: Catalog::Agent.create!(name:, kind: "person"), role: "created")
    end
  end

  private def create_found_copies(work)
    primary = nil
    found_copies.each do |copy|
      expression = choose_expression(work, copy, primary)
      primary ||= expression
      embody(copy, expression)
    end
  end

  # The expression a found copy embodies: a new one when its content was altered
  # (or it is the first copy), otherwise the discovery's primary expression.
  private def choose_expression(work, copy, primary)
    return build_expression(work) if copy.new_expression? || primary.nil?

    primary
  end

  private def build_expression(work)
    work.expressions.create!(title:, date: date.presence, language:, form_of_expression:)
  end

  private def embody(copy, expression)
    manifestation = Catalog::Manifestation.create!(
      title:, carrier: online_carrier, access_address: copy.url,
      statement_of_responsibility: copy.statement_of_responsibility.presence)
    Catalog::Embodiment.create!(expression:, manifestation:)
    return if copy.reproduction_of_manifestation_id.blank?

    manifestation.manifestation_relationships.create!(
      kind: "reproduction", related_manifestation_id: copy.reproduction_of_manifestation_id)
  end

  private def create_external_references(work)
    external_references.each do |reference|
      work.external_references.create!(
        url: reference.url, source: reference.source.presence, note: reference.note.presence)
    end
  end

  private def open_determination(work)
    determination = Copyright::Determination.create!(
      work:, status: "researching",
      first_publication_year: first_publication_year.presence,
      first_publication_country: first_publication_country.presence)
    @determination = determination
    # Rule 1 is deterministic: a known pre-1978 year settles to +determined+
    # with a computed public-domain date; otherwise it stays +researching+.
    Copyright::Determination::TermExpiration.new(determination).apply!
  end

  private def start_workflow(work, actor)
    project = Workflow::Project.start(work:, lead: actor)
    project.steps.complete(:discovery, by: actor)
  end

  private def publish_listing(work)
    @listing = Magic::Listing.create!(work:, exposure:)
  end

  private def language
    Catalog::Language.find_or_create_by!(code: DEFAULT_LANGUAGE_CODE) do |record|
      record.name = DEFAULT_LANGUAGE_NAME
    end
  end

  private def form_of_expression
    Catalog::FormOfExpression.find_or_create_by!(name: DEFAULT_FORM_OF_EXPRESSION)
  end

  private def online_carrier
    Catalog::Carrier.find_or_create_by!(name: ONLINE_CARRIER)
  end
end
