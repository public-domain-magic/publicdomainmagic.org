# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::CarriersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in :kerrick
    @catalog_carrier = catalog_carriers(:pdf)
  end

  test "should get index" do
    get catalog_carriers_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_carrier_url
    assert_response :success
  end

  test "should create catalog_carrier" do
    assert_difference("Catalog::Carrier.count") do
      post catalog_carriers_url, params: { catalog_carrier: { name: @catalog_carrier.name } }
    end

    assert_redirected_to catalog_carrier_url(Catalog::Carrier.last)
  end

  test "should show catalog_carrier" do
    get catalog_carrier_url(@catalog_carrier)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_carrier_url(@catalog_carrier)
    assert_response :success
  end

  test "should update catalog_carrier" do
    patch catalog_carrier_url(@catalog_carrier), params: { catalog_carrier: { name: @catalog_carrier.name } }
    assert_redirected_to catalog_carrier_url(@catalog_carrier)
  end

  test "should destroy catalog_carrier" do
    assert_difference("Catalog::Carrier.count", -1) do
      delete catalog_carrier_url(@catalog_carrier)
    end

    assert_redirected_to catalog_carriers_url
  end
end
