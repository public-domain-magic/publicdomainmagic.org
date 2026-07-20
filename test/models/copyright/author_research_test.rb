# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Copyright::AuthorResearchTest < ActiveSupport::TestCase
  test "requires a name" do
    research = copyright_author_researches(:hugard)
    research.name = ""
    assert_not research.valid?
    assert research.errors.of_kind?(:name, :blank)
  end

  test "role defaults to author_creator and shares PG's vocabulary keys" do
    research = copyright_investigations(:trick_brain).author_researches.new(
      name: "Anonymous", us_status: "unknown")
    assert_equal "author_creator", research.role
    assert_predicate research, :valid?
  end

  test "role must be in the vocabulary" do
    research = copyright_author_researches(:rigney)
    research.role = "ghostwriter"
    assert_not research.valid?
    assert research.errors.of_kind?(:role, :inclusion)
  end

  test "us_status uses the statute's words" do
    research = copyright_author_researches(:hugard)
    assert_predicate research, :domiciliary?
    research.us_status = "citizen"
    assert_not research.valid?
    assert research.errors.of_kind?(:us_status, :inclusion)
  end

  test "the catalog agent link is optional" do
    assert_equal catalog_agents(:hugard), copyright_author_researches(:hugard).agent
    assert_nil copyright_author_researches(:fitzkee).agent
    assert_predicate copyright_author_researches(:fitzkee), :valid?
  end

  test "aggregates its alias findings" do
    assert_equal 4, copyright_author_researches(:hugard).alias_findings.count
  end
end
