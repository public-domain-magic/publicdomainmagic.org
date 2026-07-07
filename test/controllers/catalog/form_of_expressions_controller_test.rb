# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::FormOfExpressionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in :kerrick
    @catalog_form_of_expression = catalog_form_of_expressions(:spoken_word)
  end

  test "should get index" do
    get catalog_form_of_expressions_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_form_of_expression_url
    assert_response :success
  end

  test "should create catalog_form_of_expression" do
    assert_difference("Catalog::FormOfExpression.count") do
      post catalog_form_of_expressions_url, params: { catalog_form_of_expression: { name: @catalog_form_of_expression.name } }
    end

    assert_redirected_to catalog_form_of_expression_url(Catalog::FormOfExpression.last)
  end

  test "should show catalog_form_of_expression" do
    get catalog_form_of_expression_url(@catalog_form_of_expression)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_form_of_expression_url(@catalog_form_of_expression)
    assert_response :success
  end

  test "should update catalog_form_of_expression" do
    patch catalog_form_of_expression_url(@catalog_form_of_expression), params: { catalog_form_of_expression: { name: @catalog_form_of_expression.name } }
    assert_redirected_to catalog_form_of_expression_url(@catalog_form_of_expression)
  end

  test "should destroy catalog_form_of_expression" do
    assert_difference("Catalog::FormOfExpression.count", -1) do
      delete catalog_form_of_expression_url(@catalog_form_of_expression)
    end

    assert_redirected_to catalog_form_of_expressions_url
  end
end
