# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Authenticates integration tests by performing a real sign-in over HTTP, so
# the app's own middleware populates +Current+ from the resulting cookie. Never
# set +Current+ by hand in tests.
module SessionTestHelper
  # Sign in as +user+, given either a fixture label or a User. All fixture
  # users share the password "secret123456" (see test/fixtures/users.yml).
  def sign_in(user)
    user = users(user) unless user.is_a?(User)
    post session_url, params: { email_address: user.email_address, password: "secret123456" }
    assert cookies[:session_token].present?
  end

  def sign_out
    delete session_url
  end
end

ActiveSupport.on_load(:action_dispatch_integration_test) do
  include SessionTestHelper
end
