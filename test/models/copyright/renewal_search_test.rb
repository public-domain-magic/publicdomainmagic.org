# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Copyright::RenewalSearchTest < ActiveSupport::TestCase
  test "requires a resource" do
    search = copyright_renewal_searches(:stanford_hugard)
    search.resource = ""
    assert_not search.valid?
    assert search.errors.of_kind?(:resource, :blank)
  end

  test "status covers the matrix markers including planned" do
    assert_predicate copyright_renewal_searches(:stanford_hugard), :clean?
    assert_predicate copyright_renewal_searches(:stanford_benson), :found_renewal?
    assert_predicate copyright_renewal_searches(:stanford_fitzkee), :planned?
  end

  test "status must be in the vocabulary" do
    search = copyright_renewal_searches(:stanford_hugard)
    search.status = "skipped"
    assert_not search.valid?
    assert search.errors.of_kind?(:status, :inclusion)
  end

  test "a found renewal holds its records" do
    assert_equal [copyright_renewal_records(:benson)],
      copyright_renewal_searches(:stanford_benson).renewal_records.to_a
  end
end
