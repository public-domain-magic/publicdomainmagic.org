# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::ManifestationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in :kerrick
    @catalog_manifestation = catalog_manifestations(:harper_1948)
  end

  test "should get index" do
    get catalog_manifestations_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_manifestation_url
    assert_response :success
  end

  test "should create catalog_manifestation" do
    assert_difference("Catalog::Manifestation.count") do
      post catalog_manifestations_url, params: { catalog_manifestation: { title: @catalog_manifestation.title, statement_of_responsibility: @catalog_manifestation.statement_of_responsibility, edition_or_issue: @catalog_manifestation.edition_or_issue, date_of_publication: @catalog_manifestation.date_of_publication, place_of_publication: @catalog_manifestation.place_of_publication, identifier: @catalog_manifestation.identifier, carrier_id: @catalog_manifestation.carrier_id, series_id: @catalog_manifestation.series_id } }
    end

    assert_redirected_to catalog_manifestation_url(Catalog::Manifestation.last)
  end

  test "should show catalog_manifestation" do
    get catalog_manifestation_url(@catalog_manifestation)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_manifestation_url(@catalog_manifestation)
    assert_response :success
  end

  test "should update catalog_manifestation" do
    patch catalog_manifestation_url(@catalog_manifestation), params: { catalog_manifestation: { title: @catalog_manifestation.title, statement_of_responsibility: @catalog_manifestation.statement_of_responsibility, edition_or_issue: @catalog_manifestation.edition_or_issue, date_of_publication: @catalog_manifestation.date_of_publication, place_of_publication: @catalog_manifestation.place_of_publication, identifier: @catalog_manifestation.identifier, carrier_id: @catalog_manifestation.carrier_id, series_id: @catalog_manifestation.series_id } }
    assert_redirected_to catalog_manifestation_url(@catalog_manifestation)
  end

  test "should destroy catalog_manifestation" do
    assert_difference("Catalog::Manifestation.count", -1) do
      delete catalog_manifestation_url(@catalog_manifestation)
    end

    assert_redirected_to catalog_manifestations_url
  end
end
