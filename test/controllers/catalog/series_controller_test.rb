# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::SeriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_series = catalog_series(:forum_books)
  end

  test "should get index" do
    get catalog_series_index_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_series_url
    assert_response :success
  end

  test "should create catalog_series" do
    assert_difference("Catalog::Series.count") do
      post catalog_series_index_url, params: { catalog_series: { name: @catalog_series.name } }
    end

    assert_redirected_to catalog_series_url(Catalog::Series.last)
  end

  test "should show catalog_series" do
    get catalog_series_url(@catalog_series)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_series_url(@catalog_series)
    assert_response :success
  end

  test "should update catalog_series" do
    patch catalog_series_url(@catalog_series), params: { catalog_series: { name: @catalog_series.name } }
    assert_redirected_to catalog_series_url(@catalog_series)
  end

  test "should destroy catalog_series" do
    assert_difference("Catalog::Series.count", -1) do
      delete catalog_series_url(@catalog_series)
    end

    assert_redirected_to catalog_series_index_url
  end
end
