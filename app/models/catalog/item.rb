# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR (WEMI): a single exemplar of a manifestation — the copy in hand, with
# its own condition, provenance, and marks. Usually one physical object, but
# may comprise more than one.
class Catalog::Item < ApplicationRecord
  belongs_to :manifestation
  belongs_to :condition

  has_many :contributions, as: :contributable, dependent: :destroy
  has_many :agents, through: :contributions
end
