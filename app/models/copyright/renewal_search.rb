# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# One renewal search actually performed (or planned) against one resource —
# a row in the research documents' search matrix. PG requires reporting the
# searches themselves, including the empty ones: a clean result set is
# evidence of nonrenewal.
class Copyright::RenewalSearch < ApplicationRecord
  # The research documents' outcome markers: +planned+ captures in-progress
  # research (a TODO row); +clean+ is ✅ (empty result set, or this work not
  # in it); +interesting+ is ⚠️; +found_renewal+ is ‼️.
  STATUSES = %w[planned clean interesting found_renewal].freeze

  belongs_to :investigation

  has_many :renewal_records, dependent: :destroy
  has_many :citations, as: :citable, dependent: :destroy

  enum :status, STATUSES.index_by(&:itself), validate: true

  validates :resource, presence: true
end
