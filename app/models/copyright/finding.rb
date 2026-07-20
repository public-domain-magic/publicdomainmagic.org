# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# A prose answer to one question of the standard PG questionnaire — the
# narrative complement to the structured research entities. Explicit negative
# findings ("I found no evidence that it was part of a serial") document
# research completeness and must appear in the report verbatim.
class Copyright::Finding < ApplicationRecord
  # The report sections of the PG questionnaire, mirroring the research
  # document's structure: Basic Information, then Phases 1–3.
  SECTIONS = %w[basic biographical bibliographical renewal].freeze

  belongs_to :investigation

  has_many :citations, as: :citable, dependent: :destroy

  enum :section, SECTIONS.index_by(&:itself), validate: true

  validates :question, presence: true
end
