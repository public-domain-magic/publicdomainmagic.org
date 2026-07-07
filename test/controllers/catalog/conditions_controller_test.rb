# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::ConditionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in :kerrick
    @catalog_condition = catalog_conditions(:worn)
  end

  test "should get index" do
    get catalog_conditions_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_condition_url
    assert_response :success
  end

  test "should create catalog_condition" do
    assert_difference("Catalog::Condition.count") do
      post catalog_conditions_url, params: { catalog_condition: { name: @catalog_condition.name } }
    end

    assert_redirected_to catalog_condition_url(Catalog::Condition.last)
  end

  test "should show catalog_condition" do
    get catalog_condition_url(@catalog_condition)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_condition_url(@catalog_condition)
    assert_response :success
  end

  test "should update catalog_condition" do
    patch catalog_condition_url(@catalog_condition), params: { catalog_condition: { name: @catalog_condition.name } }
    assert_redirected_to catalog_condition_url(@catalog_condition)
  end

  test "should destroy catalog_condition" do
    assert_difference("Catalog::Condition.count", -1) do
      delete catalog_condition_url(@catalog_condition)
    end

    assert_redirected_to catalog_conditions_url
  end
end
