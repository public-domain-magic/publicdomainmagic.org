# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Copyright::InvestigationTest < ActiveSupport::TestCase
  test "status must be in the vocabulary" do
    investigation = copyright_investigations(:royal_road)
    investigation.status = "abandoned"
    assert_not investigation.valid?
    assert investigation.errors.of_kind?(:status, :inclusion)
  end

  test "an investigation aggregates its research records" do
    investigation = copyright_investigations(:royal_road)
    assert_equal 2, investigation.author_researches.count
    assert_equal 1, investigation.republications.count
    assert_equal 2, investigation.renewal_searches.count
    assert_equal 1, investigation.findings.count
  end

  test "report renders the investigation" do
    assert_kind_of Copyright::Investigation::Report, copyright_investigations(:royal_road).report
  end
end
