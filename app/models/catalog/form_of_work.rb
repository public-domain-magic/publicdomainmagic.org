# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR work attribute: the form or genre of a work (novel, treatise, manual,
# play, symphony, map, and so on).
class Catalog::FormOfWork < ApplicationRecord
  has_many :works
end
