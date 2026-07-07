# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class User::RolableTest < ActiveSupport::TestCase
  test "an administrator with every role has every capability" do
    kerrick = users(:kerrick)

    assert kerrick.can_administer?
    assert kerrick.can_catalog?
    assert kerrick.can_research?
    assert kerrick.can_access_protected?
  end

  test "a vetted magician can only access protected books" do
    vera = users(:vetted_magician)

    assert_not vera.can_administer?
    assert_not vera.can_catalog?
    assert_not vera.can_research?
    assert vera.can_access_protected?
  end

  test "a user with no roles has no capabilities" do
    visitor = users(:visitor)

    assert_not visitor.can_administer?
    assert_not visitor.can_catalog?
    assert_not visitor.can_research?
    assert_not visitor.can_access_protected?
  end

  test "protected access is granted to librarians as well as magicians" do
    librarian_only = users(:visitor)
    librarian_only.grant :librarian, by: users(:kerrick)

    assert librarian_only.can_access_protected?
  end

  test "role? matches a granted role and rejects an ungranted one" do
    assert users(:kerrick).role?(:administrator)
    assert_not users(:vetted_magician).role?(:administrator)
  end

  test "grant creates an auditable role row" do
    role = users(:visitor).grant(:researcher, by: users(:kerrick), note: "Trusted contributor")

    assert role.persisted?
    assert_equal "researcher", role.name
    assert_equal users(:kerrick), role.granted_by
    assert_equal "Trusted contributor", role.note
  end

  test "grant defaults the note to nil" do
    role = users(:visitor).grant(:magician, by: users(:kerrick))

    assert_nil role.note
  end

  test "granting the same role twice raises" do
    assert_raises ActiveRecord::RecordInvalid do
      users(:kerrick).grant(:administrator, by: users(:kerrick))
    end
  end
end
