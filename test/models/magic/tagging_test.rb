# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Magic::TaggingTest < ActiveSupport::TestCase
  test "a tag attaches once per taggable" do
    duplicate = Magic::Tagging.new(
      tag: magic_tags(:cards), taggable: magic_listings(:royal_road))
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:tag_id, :taken)
  end

  test "tags round-trip through the listing" do
    assert_includes magic_listings(:royal_road).tags, magic_tags(:cards)
  end

  test "taggables are polymorphic, keeping the trick-data path open" do
    tagging = Magic::Tagging.create!(
      tag: magic_tags(:cards), taggable: catalog_works(:royal_road))

    assert_equal catalog_works(:royal_road), tagging.taggable
    assert_predicate tagging, :valid?
  end
end
