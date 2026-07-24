# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::Works::DeterminationsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in :kerrick }

  test "recording a notice computes the verdict and returns to the workbench" do
    work = catalog_works(:hocus_pocus_junior)

    travel_to Date.new(2026, 7, 1) do
      post catalog_work_determination_url(work),
        params: { determination: { first_publication_year: "1901", first_publication_country: "US" } }
    end

    assert_redirected_to catalog_work_path(work)
    determination = Copyright::Determination.find_by(work_id: work.id, manifestation_id: nil)
    assert_predicate determination, :public_domain?
  end

  test "recording again corrects the same determination" do
    work = catalog_works(:trick_brain)

    patch catalog_work_determination_url(work),
      params: { determination: { first_publication_year: "1990" } }

    assert_redirected_to catalog_work_path(work)
    assert_equal 1, Copyright::Determination.where(work_id: work.id, manifestation_id: nil).count
    assert_equal "determined", copyright_determinations(:trick_brain).reload.status
  end

  test "a visitor without the librarian capability is forbidden" do
    sign_in :visitor
    post catalog_work_determination_url(catalog_works(:hocus_pocus_junior)),
      params: { determination: { first_publication_year: "1901" } }
    assert_response :forbidden
  end
end
