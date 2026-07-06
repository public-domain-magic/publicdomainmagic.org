# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::ExpressionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_expression = catalog_expressions(:royal_road_text)
  end

  test "should get index" do
    get catalog_expressions_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_expression_url
    assert_response :success
  end

  test "should create catalog_expression" do
    assert_difference("Catalog::Expression.count") do
      post catalog_expressions_url, params: { catalog_expression: { date: @catalog_expression.date, form_of_expression_id: @catalog_expression.form_of_expression_id, identifier: @catalog_expression.identifier, language_id: @catalog_expression.language_id, summary: @catalog_expression.summary, title: @catalog_expression.title, work_id: @catalog_expression.work_id } }
    end

    assert_redirected_to catalog_expression_url(Catalog::Expression.last)
  end

  test "should show catalog_expression" do
    get catalog_expression_url(@catalog_expression)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_expression_url(@catalog_expression)
    assert_response :success
  end

  test "should update catalog_expression" do
    patch catalog_expression_url(@catalog_expression), params: { catalog_expression: { date: @catalog_expression.date, form_of_expression_id: @catalog_expression.form_of_expression_id, identifier: @catalog_expression.identifier, language_id: @catalog_expression.language_id, summary: @catalog_expression.summary, title: @catalog_expression.title, work_id: @catalog_expression.work_id } }
    assert_redirected_to catalog_expression_url(@catalog_expression)
  end

  test "should destroy catalog_expression" do
    assert_difference("Catalog::Expression.count", -1) do
      delete catalog_expression_url(@catalog_expression)
    end

    assert_redirected_to catalog_expressions_url
  end
end
