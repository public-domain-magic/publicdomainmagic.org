# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::ManifestationRelationshipTest < ActiveSupport::TestCase
  test "fixture is valid" do
    assert catalog_manifestation_relationships(:discoverie_facsimile_reproduction).valid?
  end

  test "kind must be in the vocabulary" do
    relationship = Catalog::ManifestationRelationship.new(
      manifestation: catalog_manifestations(:harper_1948),
      related_manifestation: catalog_manifestations(:world_1951), kind: "excerpt")
    assert_not relationship.valid?
    assert relationship.errors.of_kind?(:kind, :inclusion)
  end

  test "the manifestation, related manifestation, and kind triple is unique" do
    duplicate = Catalog::ManifestationRelationship.new(
      manifestation: catalog_manifestations(:discoverie_facsimile),
      related_manifestation: catalog_manifestations(:discoverie_1584), kind: "reproduction")
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:kind, :taken)
  end

  test "the relationship is navigable in both directions" do
    assert_includes catalog_manifestations(:discoverie_facsimile).related_manifestations,
      catalog_manifestations(:discoverie_1584)
    assert_includes catalog_manifestations(:discoverie_1584).relating_manifestations,
      catalog_manifestations(:discoverie_facsimile)
  end
end
