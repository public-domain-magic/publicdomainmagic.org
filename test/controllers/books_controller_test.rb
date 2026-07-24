# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  # --- the library is public ------------------------------------------------

  test "the library is reachable without signing in" do
    get books_url
    assert_response :success
    assert_select "h1", text: "The library"
  end

  test "the header offers sign-in to a signed-out visitor" do
    get root_url
    assert_select "a", text: "Sign in"
    assert_select "form[action=?]", session_path, count: 0
  end

  test "the header greets a signed-in visitor and offers sign-out" do
    sign_in :kerrick
    get root_url
    assert_match users(:kerrick).name, response.body
    assert_select "form[action=?]", session_path do
      assert_select "button", text: "Sign out"
    end
  end

  # --- browse & search ------------------------------------------------------

  test "browse lists public and protected books alike" do
    get books_url
    assert_response :success
    assert_select "a", text: catalog_works(:royal_road).title # public
    assert_select "a", text: catalog_works(:greater_magic).title # protected, still discoverable
  end

  test "search matches by creator name and excludes non-matches" do
    get books_url(q: "Hugard")
    assert_response :success
    assert_select "a", text: catalog_works(:royal_road).title
    assert_select "a", text: catalog_works(:discoverie).title, count: 0
  end

  test "a blank query lists the whole collection" do
    get books_url(q: "")
    assert_response :success
    assert_select "article", minimum: 3
  end

  test "a book page renders for an anonymous visitor" do
    get book_url(magic_listings(:royal_road))
    assert_response :success
    assert_select "h1", text: catalog_works(:royal_road).title
  end

  # --- the download gate matrix (Magic::Listing#accessible_to?) -------------

  test "a public book's get-section is open to a signed-out visitor" do
    get book_url(magic_listings(:royal_road))
    assert_select "#get-heading"
    assert_no_match "the magic community", response.body
  end

  test "a protected book gates its get-section from a signed-out visitor" do
    get book_url(magic_listings(:greater_magic))
    assert_response :success
    assert_match "the magic community", response.body
    assert_no_match "available to download", response.body
  end

  test "a protected book stays gated for a role-less visitor" do
    sign_in :visitor
    get book_url(magic_listings(:greater_magic))
    assert_match "the magic community", response.body
  end

  test "a protected book opens to a vetted magician" do
    sign_in :vetted_magician
    get book_url(magic_listings(:greater_magic))
    assert_no_match "the magic community", response.body
  end

  test "a protected book opens to a librarian" do
    sign_in :kerrick
    get book_url(magic_listings(:greater_magic))
    assert_no_match "the magic community", response.body
  end

  # --- "get this book" reads Catalog online editions + our published ebook --

  test "our published PDM ebook is offered on an accessible book" do
    workflow_projects(:royal_road).resources.create!(
      kind: "pdm_ebook", url: "https://cdn.example.com/royal-road.epub", note: "EPUB")

    get book_url(magic_listings(:royal_road))

    assert_select "a[href=?]", "https://cdn.example.com/royal-road.epub"
  end

  test "a Catalog online edition is offered as somewhere to read the book" do
    catalog_works(:royal_road).expressions.first.manifestations.create!(
      title: "The Royal Road to Card Magic",
      carrier: catalog_carriers(:online_resource),
      access_address: "https://archive.org/details/royal-road")

    get book_url(magic_listings(:royal_road))

    assert_select "a[href=?]", "https://archive.org/details/royal-road"
  end

  test "a physical-only book offers nothing to read yet" do
    get book_url(magic_listings(:royal_road))

    assert_match "available to download yet", response.body
  end
end
