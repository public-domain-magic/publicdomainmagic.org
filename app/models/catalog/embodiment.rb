# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR: "is embodied in" — the many-to-many link between expressions and
# manifestations. This is where aggregates (anthologies, augmented editions,
# compilations) live.
class Catalog::Embodiment < ApplicationRecord
  belongs_to :manifestation
  belongs_to :expression

  validates :expression_id, uniqueness: { scope: :manifestation_id }
end
