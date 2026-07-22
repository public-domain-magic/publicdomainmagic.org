# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  test "a tag page lists the books carrying it, without signing in" do
    get tag_url(magic_tags(:cards))
    assert_response :success
    assert_select "h1", /cards/
    assert_select "a", text: catalog_works(:royal_road).title
  end

  test "a tag with no books says so" do
    get tag_url(magic_tags(:self_working))
    assert_response :success
    assert_select "p", text: /No books carry this tag/
  end
end
