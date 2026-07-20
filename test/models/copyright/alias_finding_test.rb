# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Copyright::AliasFindingTest < ActiveSupport::TestCase
  test "requires a name" do
    finding = copyright_alias_findings(:boyce)
    finding.name = ""
    assert_not finding.valid?
    assert finding.errors.of_kind?(:name, :blank)
  end

  test "kind must be in the vocabulary" do
    finding = copyright_alias_findings(:boyce)
    finding.kind = "nickname"
    assert_not finding.valid?
    assert finding.errors.of_kind?(:kind, :inclusion)
  end

  test "carries per-claim evidence" do
    assert_equal ["https://enterthroughthelaundry.com/jean-hugard"],
      copyright_alias_findings(:boyce).citations.map(&:url)
  end
end
