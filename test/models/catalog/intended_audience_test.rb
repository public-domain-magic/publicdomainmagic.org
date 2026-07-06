# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::IntendedAudienceTest < ActiveSupport::TestCase
  test "has and belongs to many works" do
    assert_includes catalog_intended_audiences(:magicians).works, catalog_works(:royal_road)
  end
end
