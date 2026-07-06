# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::ExpressionTest < ActiveSupport::TestCase
  test "belongs to a work" do
    assert_equal catalog_works(:discoverie), catalog_expressions(:discoverie_1584_text).work
  end

  test "relating_expressions includes revisions derived from it" do
    assert_includes catalog_expressions(:discoverie_1584_text).relating_expressions,
      catalog_expressions(:discoverie_1665_text)
  end
end
