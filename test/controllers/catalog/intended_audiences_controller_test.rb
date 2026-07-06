# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::IntendedAudiencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_intended_audience = catalog_intended_audiences(:general_public)
  end

  test "should get index" do
    get catalog_intended_audiences_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_intended_audience_url
    assert_response :success
  end

  test "should create catalog_intended_audience" do
    assert_difference("Catalog::IntendedAudience.count") do
      post catalog_intended_audiences_url, params: { catalog_intended_audience: { name: @catalog_intended_audience.name } }
    end

    assert_redirected_to catalog_intended_audience_url(Catalog::IntendedAudience.last)
  end

  test "should show catalog_intended_audience" do
    get catalog_intended_audience_url(@catalog_intended_audience)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_intended_audience_url(@catalog_intended_audience)
    assert_response :success
  end

  test "should update catalog_intended_audience" do
    patch catalog_intended_audience_url(@catalog_intended_audience), params: { catalog_intended_audience: { name: @catalog_intended_audience.name } }
    assert_redirected_to catalog_intended_audience_url(@catalog_intended_audience)
  end

  test "should destroy catalog_intended_audience" do
    assert_difference("Catalog::IntendedAudience.count", -1) do
      delete catalog_intended_audience_url(@catalog_intended_audience)
    end

    assert_redirected_to catalog_intended_audiences_url
  end
end
