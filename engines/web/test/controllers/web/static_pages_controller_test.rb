=begin
`public_domain_magic`, the PublicDomainMagic.org information system
Copyright (C) 2025  Kerrick Long <me@kerricklong.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
=end

require "test_helper"

module Web
  class StaticPagesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get root_url
      assert_response :success
    end

    test "should get ebooks" do
      get ebooks_url
      assert_response :success
    end

    test "should get about" do
      get about_url
      assert_response :success
    end

    test "should get exposure" do
      get about_exposure_url
      assert_response :success
    end

    test "should get our goals" do
      get about_our_goals_url
      assert_response :success
    end

    test "should get dual license" do
      get about_dual_license_url
      assert_response :success
    end

    test "should get accessibility" do
      get about_accessibility_url
      assert_response :success
    end

    test "should get newsletter" do
      get newsletter_url
      assert_response :success
    end

    test "should get contribute" do
      get contribute_url
      assert_response :success
    end
  end
end
