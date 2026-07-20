# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class FirstRunsControllerTest < ActionDispatch::IntegrationTest
  test "new is shown when no user exists" do
    erase_all_users

    get new_first_run_url
    assert_response :success
  end

  test "new redirects home once a user exists" do
    get new_first_run_url
    assert_redirected_to root_url
  end

  test "create makes the first user an administrator and signs them in" do
    erase_all_users

    assert_difference "User.count", 1 do
      post first_run_url, params: {
user: {
        name: "Admin",
        email_address: "admin@example.com",
        password: "secret123456",
        password_confirmation: "secret123456",
      },
}
    end

    admin = User.find_by(email_address: "admin@example.com")
    assert admin.can_administer?
    assert_equal "first run", admin.roles.find_by(name: "administrator").note
    assert_nil admin.roles.find_by(name: "administrator").granted_by
    assert_redirected_to root_url
    assert cookies[:session_token].present?
  end

  test "create re-renders on invalid input" do
    erase_all_users

    assert_no_difference "User.count" do
      post first_run_url, params: {
user: {
        name: "Admin",
        email_address: "admin@example.com",
        password: "secret123456",
        password_confirmation: "mismatch",
      },
}
    end

    assert_response :unprocessable_content
  end

  test "create is blocked once a user exists" do
    assert_no_difference "User.count" do
      post first_run_url, params: {
user: {
        name: "Intruder",
        email_address: "intruder@example.com",
        password: "secret123456",
        password_confirmation: "secret123456",
      },
}
    end

    assert_redirected_to root_url
  end

  # Simulates a fresh install against the fixture world: Copyright research
  # is attributed to users by foreign key, so it must go before the users can.
  private def erase_all_users
    Copyright::Clearance.destroy_all
    Copyright::Investigation.destroy_all
    User.destroy_all
  end
end
