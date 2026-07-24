# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class DiscoveriesControllerTest < ActionDispatch::IntegrationTest
  test "a librarian can open the discovery form" do
    sign_in :kerrick
    get new_discovery_url
    assert_response :success
    assert_select "form[action=?]", discoveries_path
  end

  test "a role-less visitor is forbidden from the form" do
    sign_in :visitor
    get new_discovery_url
    assert_response :forbidden
  end

  test "a signed-out visitor is sent to sign in" do
    get new_discovery_url
    assert_redirected_to new_session_url
  end

  test "a librarian records a discovery and lands on the new book's page" do
    sign_in :kerrick

    assert_difference -> { Magic::Listing.count } => 1, -> { Catalog::Work.count } => 1 do
      post discoveries_url, params: {
discovery: {
        title: "Modern Magic",
        date: "1876",
        author_names: ["Professor Hoffmann", ""],
        first_publication_year: "1876",
        first_publication_country: "United Kingdom",
        exposure: "public",
        found_copies_attributes: {
          "0" => { url: "https://archive.org/details/modern-magic", source: "Internet Archive", content: "same" },
        },
        external_references_attributes: {
          "0" => { url: "https://geniimagazine.com/magicpedia/Modern_Magic", source: "Magicpedia" },
        },
      },
}
    end

    listing = Magic::Listing.find_by!(work: Catalog::Work.find_by!(title: "Modern Magic"))
    assert_redirected_to book_path(listing)

    follow_redirect!
    assert_select "h1", text: "Modern Magic"
    assert_select "a[href=?]", "https://archive.org/details/modern-magic"
  end

  test "the discovered book appears in the public library" do
    sign_in :kerrick
    post discoveries_url, params: {
discovery: {
      title: "The Discoverers Handbook",
      exposure: "public",
      found_copies_attributes: { "0" => { url: "https://example.com/copy", content: "same" } },
    },
}

    get books_url
    assert_select "a", text: "The Discoverers Handbook"
  end

  test "a role-less visitor cannot create a discovery" do
    sign_in :visitor

    assert_no_difference -> { Catalog::Work.count } do
      post discoveries_url, params: { discovery: { title: "Forbidden", exposure: "public" } }
    end
    assert_response :forbidden
  end

  test "an invalid submission re-renders the form" do
    sign_in :kerrick

    assert_no_difference -> { Catalog::Work.count } do
      post discoveries_url, params: { discovery: { title: "", exposure: "public" } }
    end
    assert_response :unprocessable_content
    assert_select "form[action=?]", discoveries_path
  end
end
