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

  test "home invites a signed-out visitor to sign in" do
    get root_url

    assert_select "a", text: "Sign in"
    assert_select "form[action=?]", session_path, count: 0
  end

  test "home greets a signed-in visitor and offers sign out" do
    sign_in :kerrick

    get root_url

    assert_response :success
    assert_match users(:kerrick).name, response.body
    assert_select "form[action=?]", session_path do
      assert_select "button", text: "Sign out"
    end
  end
end
