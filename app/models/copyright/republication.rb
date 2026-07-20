# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# One known edition of the work under investigation. Rule 6 needs every
# edition ever published: a renewal filed on a republication within the
# 4-year window could cover the original, and PG requires reporting how
# closely republications match (+notes+).
class Copyright::Republication < ApplicationRecord
  # Whether the researcher could get at the edition. +inaccessible+ is a
  # real, reportable research limitation (an edition "out of my reach because
  # of its rarity"); nil means not yet assessed.
  ACCESS_STATUSES = %w[examined accessible inaccessible].freeze

  belongs_to :investigation

  has_many :citations, as: :citable, dependent: :destroy

  enum :access_status, ACCESS_STATUSES.index_by(&:itself), validate: { allow_nil: true }

  validates :title, presence: true
end
