# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR table 5.1: a typed, directed relationship between two works — the source
# work and a related work — drawn from a closed vocabulary.
class Catalog::WorkRelationship < ApplicationRecord
  # The closed vocabulary of work-to-work relationship kinds (FRBR table 5.1).
  KINDS = %w[successor supplement complement summarization adaptation transformation imitation part].freeze

  belongs_to :work
  belongs_to :related_work, class_name: "Catalog::Work"

  enum :kind, KINDS.index_by(&:itself), validate: true

  validates :kind, uniqueness: { scope: %i[work_id related_work_id] }
end
