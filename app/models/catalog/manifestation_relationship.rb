# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR: a typed, directed relationship between two manifestations — a
# reproduction (reprint, facsimile) or an alternate (simultaneous editions).
class Catalog::ManifestationRelationship < ApplicationRecord
  KINDS = %w[reproduction alternate].freeze

  belongs_to :manifestation
  belongs_to :related_manifestation, class_name: "Catalog::Manifestation"

  enum :kind, KINDS.index_by(&:itself), validate: true

  validates :kind, uniqueness: { scope: %i[manifestation_id related_manifestation_id] }
end
