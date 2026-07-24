# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::WorksControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in :kerrick
    @catalog_work = catalog_works(:royal_road)
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
    # :annals rather than @catalog_work — the Copyright context holds
    # determinations against :royal_road, and cross-context references are
    # by ID (no cascade), so only a work without copyright research can go.
    assert_difference("Catalog::Work.count", -1) do
      delete catalog_work_url(catalog_works(:annals))
    end

    assert_redirected_to catalog_works_url
  end

  test "a title alone creates an entry and opens its workbench" do
    assert_difference("Catalog::Work.count") do
      post catalog_works_url, params: { catalog_work: { title: "A Freshly Found Book" } }
    end

    entry = Catalog::Work.last
    assert_equal "A Freshly Found Book", entry.title
    assert_redirected_to catalog_work_url(entry)
  end

  test "the workbench shows what is known and the computed copyright verdict" do
    get catalog_work_url(catalog_works(:royal_road))

    assert_response :success
    assert_select "#creators-heading"
    assert_select "#editions-heading"
    assert_select "#rights-heading"
    assert_match "Public domain", response.body # royal_road is cleared PD
    assert_select "legend", text: "Cite an external reference"
  end

  test "a signed-in visitor without the librarian capability is forbidden" do
    sign_in :visitor
    get catalog_works_url
    assert_response :forbidden
  end

  test "a librarian may catalog" do
    # kerrick holds the librarian role (see roles.yml); the setup signs them in.
    get new_catalog_work_url
    assert_response :success
  end
end
