require "test_helper"

class Catalog::WorksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_work = catalog_works(:one)
  end

  test "should get index" do
    get catalog_works_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_work_url
    assert_response :success
  end

  test "should create catalog_work" do
    assert_difference("Catalog::Work.count") do
      post catalog_works_url, params: { catalog_work: { date: @catalog_work.date, form_of_work_id: @catalog_work.form_of_work_id, identifier: @catalog_work.identifier, title: @catalog_work.title } }
    end

    assert_redirected_to catalog_work_url(Catalog::Work.last)
  end

  test "should show catalog_work" do
    get catalog_work_url(@catalog_work)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_work_url(@catalog_work)
    assert_response :success
  end

  test "should update catalog_work" do
    patch catalog_work_url(@catalog_work), params: { catalog_work: { date: @catalog_work.date, form_of_work_id: @catalog_work.form_of_work_id, identifier: @catalog_work.identifier, title: @catalog_work.title } }
    assert_redirected_to catalog_work_url(@catalog_work)
  end

  test "should destroy catalog_work" do
    assert_difference("Catalog::Work.count", -1) do
      delete catalog_work_url(@catalog_work)
    end

    assert_redirected_to catalog_works_url
  end
end
