require "test_helper"

module Web
  class StaticPagesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get root_url
      assert_response :success
    end

    test "should get ebooks" do
      get ebooks_url
      assert_response :success
    end

    test "should get about" do
      get about_url
      assert_response :success
    end

    test "should get exposure" do
      get about_exposure_url
      assert_response :success
    end

    test "should get our goals" do
      get about_our_goals_url
      assert_response :success
    end

    test "should get accessibility" do
      get about_accessibility_url
      assert_response :success
    end

    test "should get newsletter" do
      get newsletter_url
      assert_response :success
    end

    test "should get contribute" do
      get contribute_url
      assert_response :success
    end
  end
end
