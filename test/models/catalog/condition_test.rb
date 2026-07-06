# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::ConditionTest < ActiveSupport::TestCase
  test "has many items" do
    assert_includes catalog_conditions(:good).items, catalog_items(:royal_road_copy)
  end
end
