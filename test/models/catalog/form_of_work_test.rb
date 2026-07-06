# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::FormOfWorkTest < ActiveSupport::TestCase
  test "has many works" do
    assert_includes catalog_form_of_works(:treatise).works, catalog_works(:discoverie)
  end
end
