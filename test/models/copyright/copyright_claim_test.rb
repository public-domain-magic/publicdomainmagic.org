# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Copyright::CopyrightClaimTest < ActiveSupport::TestCase
  test "requires a claimant name" do
    claim = copyright_copyright_claims(:magic_box)
    claim.claimant_name = ""
    assert_not claim.valid?
    assert claim.errors.of_kind?(:claimant_name, :blank)
  end

  test "records the researched basis of the claim" do
    assert_match(/Lee Jacobs Productions/, copyright_copyright_claims(:magic_box).basis)
  end
end
