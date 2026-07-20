# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Renders an investigation's structured research records as the markdown
# document Project Gutenberg receives, mirroring the shape of the standard
# questionnaire: Basic Information → Phase 1 Biographical → Phase 2
# Bibliographical → Phase 3 Renewal. A PG-facing exchange object: it speaks
# PG's dialect (role option text, the search-matrix outcome markers), and the
# markdown is always regenerated from the records — never stored.
class Copyright::Investigation::Report
  # How each republication's access status reads in the report. Inaccessible
  # editions are a real, reportable research limitation.
  ACCESS_CAVEATS = {
    "examined" => "examined",
    "accessible" => "accessible, not yet examined",
    "inaccessible" => "inaccessible",
  }.freeze

  # The search-matrix outcome markers from the research documents' key.
  STATUS_MARKERS = {
    "planned" => "🔲",
    "clean" => "✅",
    "interesting" => "⚠️",
    "found_renewal" => "‼️",
  }.freeze

  # The statutory phrase for each researched US status (17 U.S.C. speaks of a
  # "national or domiciliary of the United States").
  US_STATUS_PHRASES = {
    "national" => "a national of the United States",
    "domiciliary" => "a domiciliary of the United States",
    "neither" => "neither a national nor a domiciliary of the United States",
    "unknown" => "of unknown U.S. status",
  }.freeze

  # Takes the Copyright::Investigation whose records are being reported.
  def initialize(investigation)
    @investigation = investigation
  end

  # The complete submission document as markdown.
  def to_markdown
    sections = [
      preamble,
      basic_information,
      biographical_research,
      bibliographical_research,
      renewal_research,
]
    "#{sections.map { |lines| lines.join("\n") }.join("\n\n")}\n"
  end

  private def preamble
    [
      "# Rule 6 Research",
      "",
      "#{work.title}, #{determination.first_publication_year}. " \
        "Research #{investigation.status.humanize.downcase}.",
]
  end

  private def basic_information
    lines = ["# Basic Information", ""]
    lines << "## Original Title" << "" << work.title.to_s << ""
    lines << "## Original Publication Date" << "" << determination.first_publication_year.to_s << ""
    lines << "## Author(s) Name" << ""
    investigation.author_researches.each do |research|
      lines << "* #{research.name}, #{role_text(research)}"
    end
    lines << "" << "## Original copyright registration record identifier, if known" << ""
    lines << (determination.initial_registration_number.presence || "Unknown.")
    lines.concat findings_for("basic")
  end

  private def biographical_research
    lines = ["# Phase 1: Biographical Research"]
    investigation.author_researches.each do |research|
      lines.concat author_research_lines(research)
    end
    lines.concat copyright_claim_lines
    lines.concat findings_for("biographical")
  end

  private def author_research_lines(research)
    lines = ["", "## #{research.name}, #{role_text(research)}", ""]
    lines << "#{research.name} was #{US_STATUS_PHRASES.fetch(research.us_status)} " \
      "at the time of publication.#{citation_suffix(research)}"
    lines << research.basis.to_s if research.basis.present?
    dates = vital_dates(research)
    lines << dates unless dates.empty?
    lines.concat alias_lines(research)
    lines.concat heir_lines(research)
  end

  private def vital_dates(research)
    parts = [
      ("Born #{research.birth_date}" if research.birth_date.present?),
      ("Died #{research.death_date}" if research.death_date.present?),
].compact
    parts.empty? ? "" : "#{parts.join('. ')}."
  end

  private def alias_lines(research)
    return [] if research.alias_findings.none?

    lines = ["", "Aliases, variations, and pseudonyms:", ""]
    research.alias_findings.each do |alias_finding|
      lines << "* **#{alias_finding.name}**, #{alias_finding.kind} name." \
        "#{citation_suffix(alias_finding)}"
    end
    lines
  end

  private def heir_lines(research)
    return [] if research.heirs.blank?

    ["", "Heirs or other parties who might have had the right to renew:", "", research.heirs.to_s]
  end

  private def copyright_claim_lines
    return [] if investigation.copyright_claims.none?

    lines = ["", "## Third-Party Copyright Claims", ""]
    investigation.copyright_claims.each do |claim|
      lines << "* #{claim.claimant_name}: #{claim.basis}#{citation_suffix(claim)}"
    end
    lines
  end

  private def bibliographical_research
    lines = ["# Phase 2: Bibliographical Research"]
    if investigation.republications.any?
      lines << "" << "## Republications" << ""
      investigation.republications.each do |republication|
        lines.concat republication_lines(republication)
      end
    end
    lines.concat findings_for("bibliographical")
  end

  private def republication_lines(republication)
    entry = [
      republication.title,
      republication.year,
      republication.publisher,
      republication.edition_designation,
].compact_blank.join(", ")
    access_status = republication.access_status
    entry += " (#{ACCESS_CAVEATS.fetch(access_status)})" unless access_status.nil?
    lines = ["* #{entry}#{citation_suffix(republication)}"]
    lines << "  * #{republication.notes}" if republication.notes.present?
    lines
  end

  private def renewal_research
    lines = ["# Phase 3: Renewal Research"]
    if investigation.renewal_searches.any?
      lines << "" << "Search outcome key: 🔲 = planned; ✅ = searched, no relevant records; " \
        "⚠️ = searched, found something interesting; ‼️ = searched, found renewal." << ""
      investigation.renewal_searches.each do |search|
        lines.concat renewal_search_lines(search)
      end
    end
    lines.concat findings_for("renewal")
  end

  private def renewal_search_lines(search)
    line = "* #{STATUS_MARKERS.fetch(search.status)} #{search.resource} — “#{search.terms}”"
    line += " (searched #{search.searched_on})" if search.searched_on.present?
    lines = ["#{line}#{citation_suffix(search)}"]
    lines << "  * #{search.outcome}" if search.outcome.present?
    search.renewal_records.each do |record|
      lines << "  * #{renewal_record_text(record)}"
    end
    lines
  end

  private def renewal_record_text(record)
    text = "Renewal #{record.renewal_number}"
    text += " of registration #{record.registration_number}" if record.registration_number.present?
    text += ", held by #{record.holder}" if record.holder.present?
    text += ". #{applies_text(record)}"
    text += " #{record.assessment}" if record.assessment.present?
    "#{text}#{citation_suffix(record)}"
  end

  private def applies_text(record)
    case record.applies
    when true then "This renewal applies to the work under investigation."
    when false then "This renewal does not apply to the work under investigation."
    else "Applicability not yet assessed."
    end
  end

  private def findings_for(section)
    investigation.findings.where(section:).flat_map do |finding|
      ["", "## #{finding.question}", "", "#{finding.answer}#{citation_suffix(finding)}"]
    end
  end

  private def role_text(research)
    Copyright::ClearanceAuthor::ROLES.fetch(research.role.to_sym)
  end

  private def citation_suffix(record)
    record.citations.map { |citation| " Source: <#{citation.url}>." }.join
  end

  private def determination
    investigation.determination
  end

  # The Catalog work the reported determination is anchored to.
  private def work
    determination.work
  end

  private attr_reader :investigation
end
