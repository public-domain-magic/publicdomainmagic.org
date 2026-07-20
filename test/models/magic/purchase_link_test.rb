# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Magic::PurchaseLinkTest < ActiveSupport::TestCase
  test "requires a label" do
    link = magic_purchase_links(:greater_magic_dealer)
    link.label = ""
    assert_not link.valid?
    assert link.errors.of_kind?(:label, :blank)
  end

  test "requires a url but accepts any shape" do
    link = magic_purchase_links(:greater_magic_dealer)
    link.url = ""
    assert_not link.valid?
    assert link.errors.of_kind?(:url, :blank)
  end

  test "a listing orders its purchase links by position" do
    listing = magic_listings(:greater_magic)
    listing.purchase_links.create!(label: "Publisher direct", url: "https://example.com/direct", position: 2)

    assert_equal ["Buy a used copy (dealer)", "Publisher direct"],
      listing.purchase_links.reload.map(&:label)
  end
end
