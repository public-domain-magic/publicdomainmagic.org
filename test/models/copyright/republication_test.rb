# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Copyright::RepublicationTest < ActiveSupport::TestCase
  test "requires a title" do
    republication = copyright_republications(:royal_road_world_1951)
    republication.title = ""
    assert_not republication.valid?
    assert republication.errors.of_kind?(:title, :blank)
  end

  test "access_status must be in the vocabulary when present" do
    republication = copyright_republications(:trick_brain_third_printing)
    assert_predicate republication, :inaccessible?

    republication.access_status = "borrowed"
    assert_not republication.valid?
    assert republication.errors.of_kind?(:access_status, :inclusion)
  end

  test "access_status may be unassessed" do
    republication = copyright_republications(:trick_brain_saint_raphael)
    republication.access_status = nil
    assert_predicate republication, :valid?
  end
end
