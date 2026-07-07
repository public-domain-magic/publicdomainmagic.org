# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in :kerrick
    @catalog_item = catalog_items(:royal_road_copy)
  end

  test "should get index" do
    get catalog_items_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_item_url
    assert_response :success
  end

  test "should create catalog_item" do
    assert_difference("Catalog::Item.count") do
      post catalog_items_url, params: { catalog_item: { condition_id: @catalog_item.condition_id, identifier: @catalog_item.identifier, manifestation_id: @catalog_item.manifestation_id, marks: @catalog_item.marks, provenance: @catalog_item.provenance } }
    end

    assert_redirected_to catalog_item_url(Catalog::Item.last)
  end

  test "should show catalog_item" do
    get catalog_item_url(@catalog_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_item_url(@catalog_item)
    assert_response :success
  end

  test "should update catalog_item" do
    patch catalog_item_url(@catalog_item), params: { catalog_item: { condition_id: @catalog_item.condition_id, identifier: @catalog_item.identifier, manifestation_id: @catalog_item.manifestation_id, marks: @catalog_item.marks, provenance: @catalog_item.provenance } }
    assert_redirected_to catalog_item_url(@catalog_item)
  end

  test "should destroy catalog_item" do
    assert_difference("Catalog::Item.count", -1) do
      delete catalog_item_url(@catalog_item)
    end

    assert_redirected_to catalog_items_url
  end
end
