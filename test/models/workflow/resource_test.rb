# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Workflow::ResourceTest < ActiveSupport::TestCase
  test "requires a url" do
    resource = workflow_resources(:royal_road_text_repo)
    resource.url = ""
    assert_not resource.valid?
    assert resource.errors.of_kind?(:url, :blank)
  end

  test "kind must be in the vocabulary" do
    resource = workflow_resources(:greater_magic_listing)
    resource.kind = "torrent"
    assert_not resource.valid?
    assert resource.errors.of_kind?(:kind, :inclusion)
  end

  test "a project has one text repo" do
    duplicate = workflow_projects(:royal_road).resources.new(
      kind: :text_repo, url: "git@example.com:books/duplicate.git")
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:kind, :taken)
  end

  test "other kinds allow multiple rows per project" do
    second = workflow_projects(:greater_magic).resources.new(
      kind: :other, url: "https://example.com/another-dealer-listing")
    assert_predicate second, :valid?
  end

  test "a text repo locator may be an SSH clone URL" do
    assert_match(/\Agit@/, workflow_resources(:royal_road_text_repo).url)
  end
end
