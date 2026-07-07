# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# A person with an account. Users are app-wide identity infrastructure shared
# by every bounded context: Workflow and Copyright attribute work to them,
# Catalog and Magic gate write and download access through their capabilities.
#
# Authorization lives in the {User::Rolable} concern as capability predicates
# (+can_catalog?+, +can_access_protected?+, …); a user with no role grants sits
# in the public tier. Passwords are optional at the model layer
# (+has_secure_password validations: false+) so a user may be created before a
# password is set.
class User < ApplicationRecord
  include Rolable

  has_secure_password validations: false
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: -> (e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true
  # `validations: false` drops the built-in confirmation check (so password-less
  # records stay valid); keep confirmation when a password is actually being set.
  validates :password, confirmation: true, allow_nil: true
end
