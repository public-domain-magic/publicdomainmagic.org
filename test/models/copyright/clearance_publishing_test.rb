# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Copyright::ClearancePublishingTest < ActiveSupport::TestCase
  test "kinds store PG's literal option text" do
    assert_equal "Copyright notice or similar",
      copyright_clearance_publishings(:world_1951).kind_for_database
  end

  test "kind must be in PG's vocabulary" do
    publishing = copyright_clearance_publishings(:world_1951)
    publishing.kind = "second_printing"
    assert_not publishing.valid?
    assert publishing.errors.of_kind?(:kind, :inclusion)
  end

  test "a clearance lists its publishings in form order" do
    assert_equal %w[1951 1948], copyright_clearances(:royal_road).publishings.map(&:year)
  end
end
