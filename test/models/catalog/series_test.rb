# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::SeriesTest < ActiveSupport::TestCase
  test "has many manifestations" do
    assert_includes catalog_series(:dover_occult).manifestations, catalog_manifestations(:discoverie_facsimile)
  end
end
