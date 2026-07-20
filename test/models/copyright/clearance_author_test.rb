# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Copyright::ClearanceAuthorTest < ActiveSupport::TestCase
  test "roles store PG's literal option text" do
    assert_equal "Author/Creator", copyright_clearance_authors(:hugard).role_for_database
    assert_equal "Commentator", copyright_clearance_authors(:fleming).role_for_database
    assert_equal "Illustrator", copyright_clearance_authors(:rigney).role_for_database
  end

  test "role predicates use the snake_case labels" do
    assert_predicate copyright_clearance_authors(:hugard), :author_creator?
    assert_predicate copyright_clearance_authors(:fleming), :commentator?
  end

  test "role must be in PG's vocabulary" do
    author = copyright_clearance_authors(:hugard)
    author.role = "ghostwriter"
    assert_not author.valid?
    assert author.errors.of_kind?(:role, :inclusion)
  end
end
