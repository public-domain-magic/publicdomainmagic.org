# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# The researched biographical facts about one creator, gathered for a renewal
# investigation. Rule 6 requires researching ALL creators — commentators and
# illustrators included, hence the role vocabulary — because any of them (or
# their heirs) could have renewed.
#
# These facts live here, not on Catalog::Agent: this context's biography
# carries per-claim evidence ({Copyright::Citation}) and exists to drive
# renewal searches. The +agent+ link to the catalog identity is optional.
class Copyright::AuthorResearch < ApplicationRecord
  # The statute's words: 17 U.S.C. speaks of a "national or domiciliary of
  # the United States"; PG's "citizen/resident" paraphrases them.
  US_STATUSES = %w[national domiciliary neither unknown].freeze

  belongs_to :investigation
  belongs_to :agent, class_name: "Catalog::Agent", optional: true

  has_many :alias_findings, dependent: :destroy
  has_many :citations, as: :citable, dependent: :destroy

  enum :role, Copyright::ClearanceAuthor::ROLES.keys.map(&:to_s).index_by(&:itself),
    default: "author_creator", validate: true
  enum :us_status, US_STATUSES.index_by(&:itself), validate: true

  validates :name, presence: true
end
