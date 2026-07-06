# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::ItemTest < ActiveSupport::TestCase
  test "belongs to a manifestation and a condition" do
    item = catalog_items(:royal_road_copy)
    assert_equal catalog_manifestations(:harper_1948), item.manifestation
    assert_equal catalog_conditions(:good), item.condition
  end

  test "owned is a valid contribution role on an item" do
    contribution = Catalog::Contribution.new(
      agent: catalog_agents(:hugard), contributable: catalog_items(:royal_road_copy), role: "owned")
    assert contribution.valid?
  end

  test "published is not a valid contribution role on an item" do
    contribution = Catalog::Contribution.new(
      agent: catalog_agents(:harper_brothers), contributable: catalog_items(:royal_road_copy), role: "published")
    assert_not contribution.valid?
    assert_includes contribution.errors[:role], "published is not a item-level role"
  end
end
