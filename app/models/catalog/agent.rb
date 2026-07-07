# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR Group 2 / IFLA LRM: a person or corporate body responsible for the
# creation, realization, production, or ownership of resources. Holds only
# bibliographic identity; researched biographical facts (residency, heirs,
# sources) belong to the Copyright context.
class Catalog::Agent < ApplicationRecord
  # The closed vocabulary of agent kinds, mirroring FRBR Group 2's split
  # between an individual person and a corporate body.
  KINDS = %w[person corporate_body].freeze

  has_many :nomens, dependent: :destroy
  has_many :contributions, dependent: :destroy

  enum :kind, KINDS.index_by(&:itself), validate: true

  validates :name, presence: true
end
