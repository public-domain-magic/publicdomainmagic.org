# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR: creator/contributor is a relationship, not an attribute. Links an
# agent to the WEMI level its role operates on. The enum derives from
# ROLES_BY_LEVEL so the vocabulary and the level rules cannot drift.
class Catalog::Contribution < ApplicationRecord
  # The contribution roles permitted at each WEMI level, keyed by
  # +contributable_type+. Both the role enum and the level validation derive
  # from this map, so a role can never be attached to the wrong level.
  ROLES_BY_LEVEL = {
    "Catalog::Work" => %w[created],
    "Catalog::Expression" => %w[wrote translated edited illustrated performed taught],
    "Catalog::Manifestation" => %w[published printed],
    "Catalog::Item" => %w[owned donated annotated],
  }.freeze

  belongs_to :agent
  belongs_to :contributable, polymorphic: true

  enum :role, ROLES_BY_LEVEL.values.flatten.index_by(&:itself), validate: true

  validate :role_appropriate_for_level

  private def role_appropriate_for_level
    return if role.blank? || contributable_type.blank?
    return if ROLES_BY_LEVEL[contributable_type]&.include?(role)

    errors.add(:role, "#{role} is not a #{contributable_type.demodulize.downcase}-level role")
  end
end
