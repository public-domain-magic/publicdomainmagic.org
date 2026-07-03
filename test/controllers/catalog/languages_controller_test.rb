require "test_helper"

class Catalog::LanguagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_language = catalog_languages(:one)
  end

  test "should get index" do
    get catalog_languages_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_language_url
    assert_response :success
  end

  test "should create catalog_language" do
    assert_difference("Catalog::Language.count") do
      post catalog_languages_url, params: { catalog_language: { code: @catalog_language.code, name: @catalog_language.name } }
    end

    assert_redirected_to catalog_language_url(Catalog::Language.last)
  end

  test "should show catalog_language" do
    get catalog_language_url(@catalog_language)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_language_url(@catalog_language)
    assert_response :success
  end

  test "should update catalog_language" do
    patch catalog_language_url(@catalog_language), params: { catalog_language: { code: @catalog_language.code, name: @catalog_language.name } }
    assert_redirected_to catalog_language_url(@catalog_language)
  end

  test "should destroy catalog_language" do
    assert_difference("Catalog::Language.count", -1) do
      delete catalog_language_url(@catalog_language)
    end

    assert_redirected_to catalog_languages_url
  end
end
