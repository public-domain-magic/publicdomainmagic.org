# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::WorkRelationshipTest < ActiveSupport::TestCase
  test "fixture is valid" do
    assert catalog_work_relationships(:hocus_pocus_adaptation).valid?
  end

  test "kind must be in the vocabulary" do
    relationship = Catalog::WorkRelationship.new(
      work: catalog_works(:royal_road), related_work: catalog_works(:discoverie), kind: "borrows")
    assert_not relationship.valid?
    assert relationship.errors.of_kind?(:kind, :inclusion)
  end

  test "the work, related work, and kind triple is unique" do
    duplicate = Catalog::WorkRelationship.new(
      work: catalog_works(:hocus_pocus_junior), related_work: catalog_works(:discoverie), kind: "adaptation")
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:kind, :taken)
  end

  test "the relationship is navigable in both directions" do
    assert_includes catalog_works(:hocus_pocus_junior).related_works, catalog_works(:discoverie)
    assert_includes catalog_works(:discoverie).relating_works, catalog_works(:hocus_pocus_junior)
  end
end
