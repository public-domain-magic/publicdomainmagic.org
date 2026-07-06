# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::EmbodimentTest < ActiveSupport::TestCase
  test "an expression can be embodied in multiple manifestations" do
    manifestations = catalog_expressions(:royal_road_text).manifestations
    assert_includes manifestations, catalog_manifestations(:harper_1948)
    assert_includes manifestations, catalog_manifestations(:world_1951)
  end

  test "a manifestation and expression pair is unique" do
    duplicate = Catalog::Embodiment.new(
      expression: catalog_expressions(:royal_road_text),
      manifestation: catalog_manifestations(:harper_1948),
      position: 2)
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:expression_id, :taken)
  end
end
