# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::ManifestationTest < ActiveSupport::TestCase
  test "is valid without a series" do
    manifestation = catalog_manifestations(:harper_1948)
    assert_nil manifestation.series
    assert manifestation.valid?
  end

  test "embodied expressions are ordered by position" do
    manifestation = Catalog::Manifestation.create!(title: "An Anthology", carrier: catalog_carriers(:print))
    first = catalog_expressions(:royal_road_text)
    second = catalog_expressions(:discoverie_1584_text)

    manifestation.embodiments.create!(expression: second, position: 2)
    manifestation.embodiments.create!(expression: first, position: 1)

    assert_equal [first, second], manifestation.reload.expressions.to_a
  end

  test "related_manifestations includes the reproduced original" do
    assert_includes catalog_manifestations(:discoverie_facsimile).related_manifestations,
      catalog_manifestations(:discoverie_1584)
  end
end
