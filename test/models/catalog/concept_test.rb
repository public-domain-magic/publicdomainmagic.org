# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::ConceptTest < ActiveSupport::TestCase
  test "requires a name" do
    concept = Catalog::Concept.new
    assert_not concept.valid?
    assert concept.errors.of_kind?(:name, :blank)
  end

  test "name is unique" do
    duplicate = Catalog::Concept.new(name: catalog_concepts(:card_magic).name)
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:name, :taken)
  end
end
