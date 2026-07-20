# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Copyright::FindingTest < ActiveSupport::TestCase
  test "requires a question" do
    finding = copyright_findings(:royal_road_serial)
    finding.question = ""
    assert_not finding.valid?
    assert finding.errors.of_kind?(:question, :blank)
  end

  test "section must be in the questionnaire's vocabulary" do
    finding = copyright_findings(:royal_road_serial)
    finding.section = "appendix"
    assert_not finding.valid?
    assert finding.errors.of_kind?(:section, :inclusion)
  end

  test "preserves a negative finding verbatim" do
    assert_equal "I found no evidence that it was part of a serial.",
      copyright_findings(:royal_road_serial).answer
  end
end
