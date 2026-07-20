# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# The structured research container behind a determination, named after USCO
# Circular 22, *How to Investigate the Copyright Status of a Work*. The
# renewal-era research Project Gutenberg calls "Rule 6" lives here as
# entities — author research, alias findings, republications, renewal
# searches and records, third-party claims, and narrative findings — and the
# markdown document PG receives is generated as a {Report} of that data, not
# kept as a text blob.
class Copyright::Investigation < ApplicationRecord
  # Whether the research is still accumulating records. Phase completeness is
  # derivable from findings and searches, so the binary stands for now.
  STATUSES = %w[in_progress complete].freeze

  belongs_to :determination
  belongs_to :researcher, class_name: "User"

  has_many :author_researches, dependent: :destroy
  has_many :republications, dependent: :destroy
  has_many :renewal_searches, dependent: :destroy
  has_many :copyright_claims, dependent: :destroy
  has_many :findings, -> { order(:position) }, inverse_of: :investigation, dependent: :destroy

  enum :status, STATUSES.index_by(&:itself), validate: true

  # The markdown submission document for this investigation, rendered from
  # the structured research records.
  def report
    Report.new(self)
  end
end
