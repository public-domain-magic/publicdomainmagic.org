# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class SessionTest < ActiveSupport::TestCase
  test "generates an opaque token on creation" do
    session = users(:kerrick).sessions.create!
    assert session.token.present?
  end
end
