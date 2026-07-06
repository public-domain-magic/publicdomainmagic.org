# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR item attribute: the physical condition of an item (its variances from
# the manifestation — missing pages, rebinding, wear).
class Catalog::Condition < ApplicationRecord
  has_many :items
end
