# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Loads the real book corpus from +db/seeds/*.yml+ through the model layer.
# Every row is created with the ordinary model API (never +FixtureSet+), so
# validations, normalization, and enums run. Idempotent: each entity is matched
# on a natural key with +find_or_create_by!+, so re-running +bin/rails db:seed+
# only inserts rows that do not exist yet — safe in production, with no
# destructive operations.
#
# The launch corpus is the three already-researched titles (The Royal Road to
# Card Magic, The Discoverie of Witchcraft, Greater Magic). The Workflow context
# is intentionally not seeded: its +Project+ requires a +lead+ user, which does
# not exist until the first-run flow creates the administrator. New titles are a
# data-entry task — add rows to the YAML, no code change.
class Seeds::Loader
  # Build a loader that reads its YAML from +root+ (defaults to +db/seeds+).
  def initialize(root: Rails.root.join("db/seeds"))
    @root = root
    @form_of_works = {}
    @form_of_expressions = {}
    @languages = {}
    @carriers = {}
    @series = {}
    @intended_audiences = {}
    @agents = {}
    @works = {}
    @expressions = {}
    @manifestations = {}
    @concepts = {}
    @listings = {}
    @tags = {}
  end

  # Seed the corpus in dependency order, wrapped in a single transaction so a
  # malformed row leaves the database untouched.
  def load!
    ActiveRecord::Base.transaction do
      load_catalog
      load_copyright
      load_magic
    end
    nil
  end

  private def load_catalog
    data = Psych.load_file(@root.join("catalog.yml"))

    data["form_of_works"]&.each do |label, attrs|
      @form_of_works[label] = Catalog::FormOfWork.find_or_create_by!(name: attrs.fetch("name"))
    end
    data["form_of_expressions"]&.each do |label, attrs|
      @form_of_expressions[label] = Catalog::FormOfExpression.find_or_create_by!(name: attrs.fetch("name"))
    end
    data["languages"]&.each do |label, attrs|
      @languages[label] = Catalog::Language.find_or_create_by!(code: attrs.fetch("code")) do |language|
        language.name = attrs.fetch("name")
      end
    end
    data["carriers"]&.each do |label, attrs|
      @carriers[label] = Catalog::Carrier.find_or_create_by!(name: attrs.fetch("name"))
    end
    data["series"]&.each do |label, attrs|
      @series[label] = Catalog::Series.find_or_create_by!(name: attrs.fetch("name"))
    end
    data["intended_audiences"]&.each do |label, attrs|
      @intended_audiences[label] = Catalog::IntendedAudience.find_or_create_by!(name: attrs.fetch("name"))
    end

    data["agents"]&.each do |label, attrs|
      @agents[label] = Catalog::Agent.find_or_create_by!(name: attrs.fetch("name")) do |agent|
        agent.kind = attrs.fetch("kind")
        agent.birth_date = attrs["birth_date"]
        agent.death_date = attrs["death_date"]
      end
    end
    data["nomens"]&.each do |_label, attrs|
      @agents.fetch(attrs.fetch("agent")).nomens.find_or_create_by!(
        name: attrs.fetch("name"), kind: attrs.fetch("kind"))
    end

    data["works"]&.each do |label, attrs|
      work = Catalog::Work.find_or_create_by!(title: attrs.fetch("title"), date: attrs.fetch("date")) do |record|
        record.form_of_work = @form_of_works.fetch(attrs.fetch("form_of_work"))
      end
      Array(attrs["intended_audiences"]).each do |audience_label|
        audience = @intended_audiences.fetch(audience_label)
        work.intended_audiences << audience unless work.intended_audiences.include?(audience)
      end
      @works[label] = work
    end

    data["expressions"]&.each do |label, attrs|
      @expressions[label] = @works.fetch(attrs.fetch("work")).expressions.find_or_create_by!(
        title: attrs.fetch("title"), date: attrs.fetch("date")) do |expression|
        expression.language = @languages.fetch(attrs.fetch("language"))
        expression.form_of_expression = @form_of_expressions.fetch(attrs.fetch("form_of_expression"))
      end
    end

    data["manifestations"]&.each do |label, attrs|
      @manifestations[label] = Catalog::Manifestation.find_or_create_by!(
        title: attrs.fetch("title"), date_of_publication: attrs.fetch("date_of_publication")) do |manifestation|
        manifestation.carrier = @carriers.fetch(attrs.fetch("carrier"))
        manifestation.statement_of_responsibility = attrs["statement_of_responsibility"]
        manifestation.place_of_publication = attrs["place_of_publication"]
        manifestation.edition_or_issue = attrs["edition_or_issue"]
        series_label = attrs["series"]
        manifestation.series = @series.fetch(series_label) if series_label
      end
    end

    data["embodiments"]&.each do |attrs|
      Catalog::Embodiment.find_or_create_by!(
        expression: @expressions.fetch(attrs.fetch("expression")),
        manifestation: @manifestations.fetch(attrs.fetch("manifestation"))) do |embodiment|
        embodiment.position = attrs["position"]
      end
    end

    data["contributions"]&.each do |attrs|
      Catalog::Contribution.find_or_create_by!(
        agent: @agents.fetch(attrs.fetch("agent")),
        contributable: polymorphic(attrs.fetch("contributable")),
        role: attrs.fetch("role"))
    end

    data["concepts"]&.each do |label, attrs|
      @concepts[label] = Catalog::Concept.find_or_create_by!(name: attrs.fetch("name"))
    end

    data["subjects"]&.each do |attrs|
      Catalog::Subject.find_or_create_by!(
        work: @works.fetch(attrs.fetch("work")),
        subject: polymorphic(attrs.fetch("subject")))
    end
  end

  private def load_copyright
    data = Psych.load_file(@root.join("copyright.yml"))

    data["determinations"]&.each do |_label, attrs|
      manifestation_label = attrs["manifestation"]
      Copyright::Determination.find_or_create_by!(
        work: @works.fetch(attrs.fetch("work")),
        manifestation: manifestation_label && @manifestations.fetch(manifestation_label)) do |determination|
        determination.status = attrs.fetch("status")
        determination.basis = attrs["basis"]
        determination.first_publication_year = attrs["first_publication_year"]
        determination.first_publication_country = attrs["first_publication_country"]
        determination.initial_registration_number = attrs["initial_registration_number"]
        determination.public_domain_on = attrs["public_domain_on"]
      end
    end
  end

  private def load_magic
    data = Psych.load_file(@root.join("magic.yml"))

    data["listings"]&.each do |label, attrs|
      @listings[label] = Magic::Listing.find_or_create_by!(work: @works.fetch(attrs.fetch("work"))) do |listing|
        listing.exposure = attrs.fetch("exposure")
        listing.featured = attrs.fetch("featured")
        listing.blurb = attrs["blurb"]
      end
    end

    data["purchase_links"]&.each do |attrs|
      @listings.fetch(attrs.fetch("listing")).purchase_links.find_or_create_by!(url: attrs.fetch("url")) do |link|
        link.label = attrs.fetch("label")
        link.position = attrs["position"]
      end
    end

    data["tags"]&.each do |label, attrs|
      @tags[label] = Magic::Tag.find_or_create_by!(name: attrs.fetch("name")) do |tag|
        concept_label = attrs["concept"]
        tag.concept = @concepts.fetch(concept_label) if concept_label
      end
    end

    data["taggings"]&.each do |attrs|
      Magic::Tagging.find_or_create_by!(
        tag: @tags.fetch(attrs.fetch("tag")),
        taggable: polymorphic(attrs.fetch("taggable")))
    end
  end

  # Resolve a fixture-style polymorphic reference — +"royal_road (Catalog::Work)"+
  # — to the already-loaded record for that label.
  private def polymorphic(reference)
    match = reference.match(/\A(?<label>.+) \((?<type>[\w:]+)\)\z/)
    raise ArgumentError, "malformed polymorphic reference: #{reference}" if match.nil?

    label = match[:label].to_s
    case match[:type]
    when "Catalog::Work" then @works.fetch(label)
    when "Catalog::Expression" then @expressions.fetch(label)
    when "Catalog::Manifestation" then @manifestations.fetch(label)
    when "Catalog::Concept" then @concepts.fetch(label)
    when "Magic::Listing" then @listings.fetch(label)
    else raise ArgumentError, "unknown polymorphic type: #{match[:type]}"
    end
  end
end
