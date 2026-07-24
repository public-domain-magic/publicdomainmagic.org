# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class DiscoveryTest < ActiveSupport::TestCase
  setup { @librarian = users(:kerrick) }

  test "a full discovery builds the whole graph across the contexts" do
    discovery = build(
      title: "The Expert at the Card Table", date: "1902",
      author_names: ["S. W. Erdnase"],
      first_publication_year: "1902", first_publication_country: "United States",
      found_copies_attributes: {
        "0" => {
url: "https://archive.org/details/expert",
source: "Internet Archive",
statement_of_responsibility: "by S. W. Erdnase",
content: "same",
},
      },
      external_references_attributes: {
        "0" => { url: "https://conjuringarchive.com/list/publication/9", source: "Conjuring Archive" },
      })

    assert discovery.save, discovery.errors.full_messages.to_sentence

    work = discovery.work
    assert_equal "The Expert at the Card Table", work.title
    assert_equal ["S. W. Erdnase"], work.agents.map(&:name)
    assert_equal ["created"], work.contributions.map(&:role)

    manifestation = work.expressions.sole.manifestations.sole
    assert_equal "https://archive.org/details/expert", manifestation.access_address
    assert_predicate manifestation, :online?
    assert_equal "by S. W. Erdnase", manifestation.statement_of_responsibility

    assert_equal "https://conjuringarchive.com/list/publication/9", work.external_references.sole.url

    project = Workflow::Project.find_by(work_id: work.id)
    assert_equal @librarian, project.lead
    assert_predicate project.steps[:discovery], :done?

    assert_predicate discovery.listing, :public_exposure?
  end

  test "a known pre-1978 year computes a determined public-domain countdown" do
    discovery = build(title: "A 1920 Book", first_publication_year: "1920")

    assert discovery.save, discovery.errors.full_messages.to_sentence

    determination = discovery.determination
    assert_equal "determined", determination.status
    assert_equal "term_expired", determination.basis
    assert_equal Date.new(2016, 1, 1), determination.public_domain_on
    assert_predicate determination, :public_domain?
  end

  test "an unknown or recent year leaves the determination researching with no countdown" do
    discovery = build(title: "Publication Year Unknown")
    assert discovery.save
    assert_equal "researching", discovery.determination.status
    assert_nil discovery.determination.public_domain_on

    recent = build(title: "A 1990 Book", first_publication_year: "1990")
    assert recent.save
    assert_equal "researching", recent.determination.status
    assert_nil recent.determination.public_domain_on
  end

  test "unchanged content shares one expression; altered content forks a new one" do
    shared = build(title: "Two Faithful Copies", found_copies_attributes: {
      "0" => { url: "https://a.example/scan", content: "same" },
      "1" => { url: "https://b.example/transcription", content: "same" },
    })
    assert shared.save, shared.errors.full_messages.to_sentence
    assert_equal 1, shared.work.expressions.count
    assert_equal 2, shared.work.expressions.sole.manifestations.count

    forked = build(title: "One Faithful, One Modernized", found_copies_attributes: {
      "0" => { url: "https://c.example/scan", content: "same" },
      "1" => { url: "https://d.example/modernized", content: "new" },
    })
    assert forked.save, forked.errors.full_messages.to_sentence
    assert_equal 2, forked.work.expressions.count
  end

  test "agents are never merged on a name string across discoveries" do
    2.times do |index|
      discovery = build(title: "Book #{index}", author_names: ["Ching Ling Foo"])
      assert discovery.save
    end

    assert_equal 2, Catalog::Agent.where(name: "Ching Ling Foo").count
  end

  test "a wholly blank found-copy or reference row is dropped, not persisted" do
    discovery = build(title: "Sparse", found_copies_attributes: { "0" => { url: "", source: "" } },
      external_references_attributes: { "0" => { url: "", source: "", note: "" } })

    assert discovery.save
    assert_equal 0, discovery.work.expressions.count
    assert_equal 0, discovery.work.external_references.count
  end

  test "an invalid discovery writes nothing" do
    discovery = build(title: "")

    assert_no_difference %w[Catalog::Work.count Magic::Listing.count Copyright::Determination.count] do
      assert_not discovery.save
    end
    assert discovery.errors.of_kind?(:title, :blank)
  end

  test "a failure mid-transaction rolls the whole graph back" do
    discovery = build(title: "Bad Reproduction", found_copies_attributes: {
      "0" => { url: "https://x.example", content: "same", reproduction_of_manifestation_id: 999_999 },
    })

    assert_no_difference %w[Catalog::Work.count Catalog::Manifestation.count Magic::Listing.count] do
      assert_not discovery.save
    end
  end

  test "it will not save without an acting librarian" do
    discovery = Discovery.new(title: "No Actor")
    discovery.librarian = nil

    assert_not discovery.save
    assert discovery.errors.added?(:base, "A librarian must be signed in to record a discovery.")
  end

  private def build(attributes)
    Discovery.new(attributes).tap { |discovery| discovery.librarian = @librarian }
  end
end
