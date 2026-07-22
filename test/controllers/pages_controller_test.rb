# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "the home page is the root and needs no sign-in" do
    get root_url
    assert_response :success
    assert_select "b.logotype" # the inline PDM logotype appears in the copy
  end

  test "the home page links into the library" do
    get root_url
    assert_select "a[href=?]", ebooks_path
  end

  test "every static page renders for an anonymous visitor" do
    [
      root_path,
      about_path,
      about_our_goals_path,
      about_exposure_path,
      about_dual_license_path,
      about_accessibility_path,
      contribute_path,
      newsletter_path,
].each do |path|
      get path
      assert_response :success, "expected #{path} to render"
    end
  end
end
