# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# A researched alias of a creator — every name a renewal could hide under.
# Overlaps Catalog::Nomen by design: this context's aliases carry evidence
# and exist to drive renewal searches; confirmed ones can be copied into
# Catalog as nomens by a Librarian.
class Copyright::AliasFinding < ApplicationRecord
  # The alias types observed in the research documents.
  KINDS = %w[birth spelling stage performance pen married maiden legal].freeze

  belongs_to :author_research

  has_many :citations, as: :citable, dependent: :destroy

  enum :kind, KINDS.index_by(&:itself), validate: true

  validates :name, presence: true
end
