# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::WorkTest < ActiveSupport::TestCase
  test "requires a title" do
    work = Catalog::Work.new(form_of_work: catalog_form_of_works(:manual))
    assert_not work.valid?
    assert work.errors.of_kind?(:title, :blank)
  end

  test "has many expressions" do
    assert_includes catalog_works(:royal_road).expressions, catalog_expressions(:royal_road_text)
  end

  test "has and belongs to many intended audiences through the renamed join table" do
    assert_includes catalog_works(:royal_road).intended_audiences, catalog_intended_audiences(:magicians)
  end

  test "date is stored as an EDTF string" do
    assert_equal "1948", catalog_works(:royal_road).date
    assert_equal "1924/1928", catalog_works(:annals).date
  end
end
