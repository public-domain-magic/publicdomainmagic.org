# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Magic::TagTest < ActiveSupport::TestCase
  test "requires a name" do
    tag = magic_tags(:cards)
    tag.name = ""
    assert_not tag.valid?
    assert tag.errors.of_kind?(:name, :blank)
  end

  test "normalizes the name and collides with the existing tag" do
    duplicate = Magic::Tag.new(name: "  Cards ")
    assert_equal "cards", duplicate.name
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:name, :taken)
  end

  test "normalization keeps hyphens" do
    assert_equal "self-working", magic_tags(:self_working).name
  end

  test "the concept bridge resolves into Catalog" do
    assert_equal catalog_concepts(:cups_and_balls), magic_tags(:cups_and_balls).concept
  end

  test "the concept bridge is optional" do
    assert_nil magic_tags(:cards).concept
    assert_predicate magic_tags(:cards), :valid?
  end
end
