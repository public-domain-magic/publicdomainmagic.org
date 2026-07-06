# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR work attribute: the class of user for which a work is intended.
class Catalog::IntendedAudience < ApplicationRecord
  has_and_belongs_to_many :works, join_table: "catalog_intended_audiences_works"
end
