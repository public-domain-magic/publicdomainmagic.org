# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR expression attribute: the form in which a work is realized (text, spoken
# word, musical notation, image, and so on).
class Catalog::FormOfExpression < ApplicationRecord
  has_many :expressions
end
