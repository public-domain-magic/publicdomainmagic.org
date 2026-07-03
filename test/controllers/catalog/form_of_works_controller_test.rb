require "test_helper"

class Catalog::FormOfWorksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_form_of_work = catalog_form_of_works(:one)
  end

  test "should get index" do
    get catalog_form_of_works_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_form_of_work_url
    assert_response :success
  end

  test "should create catalog_form_of_work" do
    assert_difference("Catalog::FormOfWork.count") do
      post catalog_form_of_works_url, params: { catalog_form_of_work: { name: @catalog_form_of_work.name } }
    end

    assert_redirected_to catalog_form_of_work_url(Catalog::FormOfWork.last)
  end

  test "should show catalog_form_of_work" do
    get catalog_form_of_work_url(@catalog_form_of_work)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_form_of_work_url(@catalog_form_of_work)
    assert_response :success
  end

  test "should update catalog_form_of_work" do
    patch catalog_form_of_work_url(@catalog_form_of_work), params: { catalog_form_of_work: { name: @catalog_form_of_work.name } }
    assert_redirected_to catalog_form_of_work_url(@catalog_form_of_work)
  end

  test "should destroy catalog_form_of_work" do
    assert_difference("Catalog::FormOfWork.count", -1) do
      delete catalog_form_of_work_url(@catalog_form_of_work)
    end

    assert_redirected_to catalog_form_of_works_url
  end
end
