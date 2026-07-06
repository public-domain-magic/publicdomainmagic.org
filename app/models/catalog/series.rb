# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR manifestation attribute: a series to which a manifestation belongs.
class Catalog::Series < ApplicationRecord
  has_many :manifestations
end
