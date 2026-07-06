# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::LanguageTest < ActiveSupport::TestCase
  test "requires a code" do
    language = Catalog::Language.new(name: "Codeless")
    assert_not language.valid?
    assert language.errors.of_kind?(:code, :blank)
  end

  test "code is unique" do
    duplicate = Catalog::Language.new(name: "American English", code: catalog_languages(:english).code)
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:code, :taken)
  end

  test "accepts three-character ISO 639-2 codes" do
    assert Catalog::Language.new(name: "German", code: "deu").valid?
  end

  test "has many expressions" do
    assert_includes catalog_languages(:english).expressions, catalog_expressions(:royal_road_text)
  end
end
