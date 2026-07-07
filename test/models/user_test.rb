# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "requires an email_address" do
    user = User.new(email_address: "")
    assert_not user.valid?
    assert user.errors.of_kind?(:email_address, :blank)
  end

  test "email_address must be unique" do
    duplicate = User.new(email_address: users(:kerrick).email_address)
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:email_address, :taken)
  end

  test "password is optional" do
    assert User.new(email_address: "no-password@example.com").valid?
  end

  test "rejects a mismatched password confirmation" do
    user = User.new(email_address: "mismatch@example.com", password: "one", password_confirmation: "two")
    assert_not user.valid?
    assert user.errors.of_kind?(:password_confirmation, :confirmation)
  end

  test "accepts a matching password confirmation" do
    user = User.new(email_address: "match@example.com", password: "same", password_confirmation: "same")
    assert user.valid?
  end
end
