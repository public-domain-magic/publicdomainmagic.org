# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "home is reachable without signing in" do
    get root_url
    assert_response :success
  end
end
