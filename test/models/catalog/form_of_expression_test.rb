# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::FormOfExpressionTest < ActiveSupport::TestCase
  test "has many expressions" do
    assert_includes catalog_form_of_expressions(:text).expressions, catalog_expressions(:royal_road_text)
  end
end
