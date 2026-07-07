# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# A granted capability tier held by a {User}.
#
# Grants are explicit and auditable: every row records who granted it
# (+granted_by+) and, optionally, the basis for the grant (+note+, e.g.
# "S.A.M. member, verified 2026-07"). A user may hold several roles at once,
# so authorization is a set of grants rather than a single column. Call sites
# never inspect roles directly; they ask a User capability predicate such as
# User#can_catalog?.
class Role < ApplicationRecord
  # The complete role vocabulary. +administrator+ grants roles; +librarian+
  # curates the catalog; +researcher+ authors copyright dossiers; +magician+
  # unlocks protected books. The absence of any role is the public tier.
  NAMES = %w[administrator librarian researcher magician].freeze

  belongs_to :user
  belongs_to :granted_by, class_name: "User", optional: true

  enum :name, NAMES.index_by(&:itself), validate: true

  validates :name, uniqueness: { scope: :user_id }
end
