# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::ContributionTest < ActiveSupport::TestCase
  test "created is valid on a work" do
    contribution = Catalog::Contribution.new(
      agent: catalog_agents(:scot), contributable: catalog_works(:discoverie), role: "created")
    assert contribution.valid?
  end

  test "created is not a valid role on an expression" do
    contribution = Catalog::Contribution.new(
      agent: catalog_agents(:rigney), contributable: catalog_expressions(:royal_road_text), role: "created")
    assert_not contribution.valid?
    assert_includes contribution.errors[:role], "created is not a expression-level role"
  end

  test "role must be in the vocabulary" do
    contribution = Catalog::Contribution.new(
      agent: catalog_agents(:hugard), contributable: catalog_works(:royal_road), role: "ghostwrote")
    assert_not contribution.valid?
    assert contribution.errors.of_kind?(:role, :inclusion)
  end

  test "a work aggregates its contributing agents" do
    assert_equal [catalog_agents(:hugard), catalog_agents(:braue)].sort_by(&:id),
      catalog_works(:royal_road).agents.sort_by(&:id)
  end
end
