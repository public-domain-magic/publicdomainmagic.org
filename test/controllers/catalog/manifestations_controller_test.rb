require "test_helper"

class Catalog::ManifestationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_manifestation = catalog_manifestations(:one)
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
      post catalog_manifestations_url, params: { catalog_manifestation: { date_of_publication: @catalog_manifestation.date_of_publication, edition_or_issue: @catalog_manifestation.edition_or_issue, expression_id: @catalog_manifestation.expression_id, form_of_expression_id: @catalog_manifestation.form_of_expression_id, language_id: @catalog_manifestation.language_id, medium_id: @catalog_manifestation.medium_id, series_id: @catalog_manifestation.series_id, statement_of_responsibility: @catalog_manifestation.statement_of_responsibility, title: @catalog_manifestation.title } }
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
    patch catalog_manifestation_url(@catalog_manifestation), params: { catalog_manifestation: { date_of_publication: @catalog_manifestation.date_of_publication, edition_or_issue: @catalog_manifestation.edition_or_issue, expression_id: @catalog_manifestation.expression_id, form_of_expression_id: @catalog_manifestation.form_of_expression_id, language_id: @catalog_manifestation.language_id, medium_id: @catalog_manifestation.medium_id, series_id: @catalog_manifestation.series_id, statement_of_responsibility: @catalog_manifestation.statement_of_responsibility, title: @catalog_manifestation.title } }
    assert_redirected_to catalog_manifestation_url(@catalog_manifestation)
  end

  test "should destroy catalog_manifestation" do
    assert_difference("Catalog::Manifestation.count", -1) do
      delete catalog_manifestation_url(@catalog_manifestation)
    end

    assert_redirected_to catalog_manifestations_url
  end
end
