# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::ExpressionRelationshipTest < ActiveSupport::TestCase
  test "fixture is valid" do
    assert catalog_expression_relationships(:discoverie_1665_revision).valid?
  end

  test "kind must be in the vocabulary" do
    relationship = Catalog::ExpressionRelationship.new(
      expression: catalog_expressions(:royal_road_text),
      related_expression: catalog_expressions(:discoverie_1584_text), kind: "rewrite")
    assert_not relationship.valid?
    assert relationship.errors.of_kind?(:kind, :inclusion)
  end

  test "the expression, related expression, and kind triple is unique" do
    duplicate = Catalog::ExpressionRelationship.new(
      expression: catalog_expressions(:discoverie_1665_text),
      related_expression: catalog_expressions(:discoverie_1584_text), kind: "revision")
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:kind, :taken)
  end

  test "the relationship is navigable in both directions" do
    assert_includes catalog_expressions(:discoverie_1665_text).related_expressions,
      catalog_expressions(:discoverie_1584_text)
    assert_includes catalog_expressions(:discoverie_1584_text).relating_expressions,
      catalog_expressions(:discoverie_1665_text)
  end
end
