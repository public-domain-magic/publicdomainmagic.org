# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class RoleTest < ActiveSupport::TestCase
  test "name must be from the known vocabulary" do
    Role::NAMES.each do |name|
      assert Role.new(user: users(:visitor), name:).valid?, "#{name} should be valid"
    end

    invalid = Role.new(user: users(:visitor), name: "superuser")
    assert_not invalid.valid?
    assert invalid.errors.of_kind?(:name, :inclusion)
  end

  test "the same role cannot be granted to a user twice" do
    duplicate = Role.new(user: users(:kerrick), name: "librarian")
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:name, :taken)
  end

  test "the same role may be held by different users" do
    assert Role.new(user: users(:visitor), name: "magician").valid?
  end

  test "granted_by is optional" do
    role = Role.new(user: users(:visitor), name: "researcher")
    assert_nil role.granted_by
    assert role.valid?
  end

  test "records who granted the role" do
    assert_equal users(:kerrick), roles(:vera_magician).granted_by
  end
end
