# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::ExternalReferenceTest < ActiveSupport::TestCase
  test "requires a url" do
    reference = Catalog::ExternalReference.new(work: catalog_works(:royal_road))
    assert_not reference.valid?
    assert reference.errors.of_kind?(:url, :blank)
  end

  test "a url is unique within a work" do
    url = "https://geniimagazine.com/magicpedia/The_Royal_Road_to_Card_Magic"
    catalog_works(:royal_road).external_references.create!(url:, source: "Magicpedia")

    duplicate = catalog_works(:royal_road).external_references.new(url:)
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:url, :taken)
  end

  test "the same url may attest two different works" do
    url = "https://example.com/shared-attestation"
    catalog_works(:royal_road).external_references.create!(url:)

    other = catalog_works(:discoverie).external_references.new(url:)
    assert_predicate other, :valid?
  end
end
