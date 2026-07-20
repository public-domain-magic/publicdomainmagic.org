# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Flat classification vocabulary — the industry-standard shortcut taken
# honestly. No hierarchy, no kinds, no axes: "cards", "self-working",
# "close-up", and "ambitious card" all coexist, because the "right" taxonomy
# is genuinely contested (see doc/contributors/magic-taxonomy-research.md).
# Tag gardening — merging, concept-linking, promotion into future
# vocabularies — is a Librarian activity, not schema.
class Magic::Tag < ApplicationRecord
  belongs_to :concept, class_name: "Catalog::Concept", optional: true

  has_many :taggings, dependent: :destroy

  normalizes :name, with: -> (n) { n.strip.downcase }

  validates :name, presence: true, uniqueness: true
end
