# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Copyright::CitationTest < ActiveSupport::TestCase
  test "requires a url" do
    citation = copyright_citations(:boyce_laundry)
    citation.url = ""
    assert_not citation.valid?
    assert citation.errors.of_kind?(:url, :blank)
  end

  test "cites across citable types" do
    assert_equal copyright_alias_findings(:boyce), copyright_citations(:boyce_laundry).citable
    assert_equal copyright_renewal_records(:benson), copyright_citations(:benson_stanford).citable
  end

  test "may carry the supporting quote and access date" do
    citation = copyright_citations(:benson_stanford)
    assert_match(/Modern Magic Manual/, citation.quote)
    assert_equal Date.new(2025, 5, 1), citation.accessed_on
  end
end
