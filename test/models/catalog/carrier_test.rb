# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::CarrierTest < ActiveSupport::TestCase
  # Regression: the carrier (formerly Medium) declared has_many :works; it must
  # own manifestations.
  test "has many manifestations" do
    assert_includes catalog_carriers(:print).manifestations, catalog_manifestations(:harper_1948)
  end
end
