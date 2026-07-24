# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Magic::ListingTest < ActiveSupport::TestCase
  test "a public listing is accessible to everyone" do
    listing = magic_listings(:royal_road)

    assert listing.accessible_to?(nil), "signed-out visitor"
    assert listing.accessible_to?(users(:visitor)), "user with no roles"
    assert listing.accessible_to?(users(:vetted_magician)), "magician"
    assert listing.accessible_to?(users(:kerrick)), "librarian"
  end

  test "a protected listing requires the protected-access capability" do
    listing = magic_listings(:greater_magic)

    assert_not listing.accessible_to?(nil), "signed-out visitor"
    assert_not listing.accessible_to?(users(:visitor)), "user with no roles"
    assert listing.accessible_to?(users(:vetted_magician)), "magician"
    assert listing.accessible_to?(users(:kerrick)), "librarian"
  end

  test "an unclassified listing is treated as not-open, like protected" do
    listing = magic_listings(:royal_road)
    listing.update!(exposure: nil)

    assert_not listing.accessible_to?(nil), "signed-out visitor"
    assert_not listing.accessible_to?(users(:visitor)), "user with no roles"
    assert listing.accessible_to?(users(:vetted_magician)), "magician"
  end

  test "one listing per work" do
    duplicate = Magic::Listing.new(work: catalog_works(:royal_road), exposure: "public")
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:work_id, :taken)
  end

  test "exposure must be in the vocabulary" do
    listing = magic_listings(:royal_road)
    listing.exposure = "secret"
    assert_not listing.valid?
    assert listing.errors.of_kind?(:exposure, :inclusion)
  end

  test "a new listing is unclassified, carrying no fabricated access class" do
    listing = Magic::Listing.new

    assert_nil listing.exposure
    assert_not listing.public_exposure?
    assert_not listing.protected_exposure?
  end

  test "a listing aggregates its tags" do
    assert_equal [magic_tags(:cards), magic_tags(:sleights)].sort_by(&:id),
      magic_listings(:royal_road).tags.sort_by(&:id)
  end
end
