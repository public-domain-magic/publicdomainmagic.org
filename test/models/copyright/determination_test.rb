# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Copyright::DeterminationTest < ActiveSupport::TestCase
  test "basis must be in the statutory vocabulary" do
    determination = copyright_determinations(:royal_road)
    determination.basis = "vibes"
    assert_not determination.valid?
    assert determination.errors.of_kind?(:basis, :inclusion)
  end

  test "basis may be nil until determined" do
    assert_predicate copyright_determinations(:trick_brain), :valid?
  end

  test "status must be in the vocabulary" do
    determination = copyright_determinations(:royal_road)
    determination.status = "cleared"
    assert_not determination.valid?
    assert determination.errors.of_kind?(:status, :inclusion)
  end

  test "pg_rule translates the statutory basis to PG's operational shorthand" do
    assert_equal "6", copyright_determinations(:royal_road).pg_rule
    assert_equal "1", copyright_determinations(:greater_magic).pg_rule
    assert_nil copyright_determinations(:trick_brain).pg_rule
  end

  test "public_domain? is true once the date has arrived" do
    travel_to Date.new(2030, 6, 1) do
      assert_predicate copyright_determinations(:royal_road), :public_domain?
      assert_not copyright_determinations(:greater_magic).public_domain?
    end
  end

  test "public_domain? is true on Public Domain Day itself" do
    travel_to Date.new(2034, 1, 1) do
      assert_predicate copyright_determinations(:greater_magic), :public_domain?
    end
  end

  test "public_domain? is false without a date" do
    assert_not copyright_determinations(:trick_brain).public_domain?
  end

  test "countdown_days counts down to a future public domain date" do
    travel_to Date.new(2030, 1, 1) do
      assert_equal 1461, copyright_determinations(:greater_magic).countdown_days
    end
  end

  test "countdown_days is nil once the work is public domain" do
    travel_to Date.new(2034, 1, 1) do
      assert_nil copyright_determinations(:greater_magic).countdown_days
    end
    assert_nil copyright_determinations(:royal_road).countdown_days
    assert_nil copyright_determinations(:trick_brain).countdown_days
  end

  test "one unscoped determination per work" do
    duplicate = Copyright::Determination.new(
      work: catalog_works(:discoverie), status: "unknown")
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:work_id, :taken)
  end

  test "a manifestation-scoped determination coexists with the unscoped one" do
    unscoped = copyright_determinations(:discoverie)
    scoped = copyright_determinations(:discoverie_facsimile)
    assert_equal unscoped.work, scoped.work
    assert_nil unscoped.manifestation
    assert_equal catalog_manifestations(:discoverie_facsimile), scoped.manifestation
    assert_predicate scoped, :valid?
  end

  test "one determination per work and manifestation pair" do
    duplicate = Copyright::Determination.new(
      work: catalog_works(:discoverie),
      manifestation: catalog_manifestations(:discoverie_facsimile),
      status: "unknown")
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:work_id, :taken)
  end

  test "the partial unique index backs the unscoped uniqueness at the DB layer" do
    duplicate = Copyright::Determination.new(
      work: catalog_works(:discoverie), status: "unknown")
    assert_raises ActiveRecord::RecordNotUnique do
      duplicate.save!(validate: false)
    end
  end

  test "record_notice opens a work's determination and computes the verdict" do
    work = catalog_works(:hocus_pocus_junior)

    travel_to Date.new(2026, 7, 1) do
      determination = Copyright::Determination.record_notice(
        work:, first_publication_year: "1901", first_publication_country: "US",
        initial_registration_number: "A1", notes: "© 1901 by Someone")

      assert_predicate determination, :public_domain?
      assert_equal "term_expired", determination.basis
      assert_equal "1901", determination.first_publication_year
      assert_equal "A1", determination.initial_registration_number
    end
  end

  test "record_notice on a 1978-or-later year records a determined, not-public-domain verdict" do
    work = catalog_works(:hocus_pocus_junior)
    determination = Copyright::Determination.record_notice(work:, first_publication_year: "1990")

    assert_equal "determined", determination.status
    assert_not determination.public_domain?
    assert_nil determination.public_domain_on
  end

  test "record_notice corrects the existing determination when recorded again" do
    work = catalog_works(:trick_brain)

    travel_to Date.new(2026, 7, 1) do
      Copyright::Determination.record_notice(work:, first_publication_year: "1901")
    end

    assert_equal 1, Copyright::Determination.where(work_id: work.id, manifestation_id: nil).count
    assert_predicate copyright_determinations(:trick_brain).reload, :public_domain?
  end

  test "record_notice without a year leaves the determination open, offering no verdict" do
    work = catalog_works(:hocus_pocus_junior)
    determination = Copyright::Determination.record_notice(work:, notes: "exterior photo only")

    assert_equal "researching", determination.status
    assert_nil determination.public_domain_on
    assert_equal "exterior photo only", determination.notes
  end
end
