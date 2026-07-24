# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::Works::ExternalReferencesControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in :kerrick }

  test "citing a reference attaches it to the entry" do
    work = catalog_works(:hocus_pocus_junior)

    assert_difference -> { work.external_references.count } do
      post catalog_work_external_references_url(work),
        params: { external_reference: { url: "https://geniimagazine.com/magicpedia/Hocus_Pocus_Junior", source: "Magicpedia" } }
    end

    assert_redirected_to catalog_work_path(work)
  end

  test "a blank URL is rejected with an alert, not a crash" do
    work = catalog_works(:hocus_pocus_junior)

    assert_no_difference -> { work.external_references.count } do
      post catalog_work_external_references_url(work), params: { external_reference: { url: "" } }
    end

    assert_redirected_to catalog_work_path(work)
    assert_equal "Url can't be blank", flash[:alert]
  end

  test "removing a reference detaches it" do
    work = catalog_works(:royal_road)
    reference = work.external_references.create!(url: "https://example.com/royal-road")

    assert_difference -> { work.external_references.count }, -1 do
      delete catalog_work_external_reference_url(work, reference)
    end

    assert_redirected_to catalog_work_path(work)
  end

  test "a visitor without the librarian capability is forbidden" do
    sign_in :visitor
    post catalog_work_external_references_url(catalog_works(:royal_road)),
      params: { external_reference: { url: "https://example.com" } }
    assert_response :forbidden
  end
end
