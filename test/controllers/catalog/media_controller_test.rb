require "test_helper"

class Catalog::MediaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_medium = catalog_media(:one)
  end

  test "should get index" do
    get catalog_media_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_medium_url
    assert_response :success
  end

  test "should create catalog_medium" do
    assert_difference("Catalog::Medium.count") do
      post catalog_media_url, params: { catalog_medium: { name: @catalog_medium.name } }
    end

    assert_redirected_to catalog_medium_url(Catalog::Medium.last)
  end

  test "should show catalog_medium" do
    get catalog_medium_url(@catalog_medium)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_medium_url(@catalog_medium)
    assert_response :success
  end

  test "should update catalog_medium" do
    patch catalog_medium_url(@catalog_medium), params: { catalog_medium: { name: @catalog_medium.name } }
    assert_redirected_to catalog_medium_url(@catalog_medium)
  end

  test "should destroy catalog_medium" do
    assert_difference("Catalog::Medium.count", -1) do
      delete catalog_medium_url(@catalog_medium)
    end

    assert_redirected_to catalog_media_url
  end
end
