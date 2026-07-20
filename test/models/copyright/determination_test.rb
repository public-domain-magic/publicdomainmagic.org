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
end
