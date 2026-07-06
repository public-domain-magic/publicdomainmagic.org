# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR expression attribute: the language of an expression, identified by its
# ISO 639 code.
class Catalog::Language < ApplicationRecord
  has_many :expressions

  validates :code, presence: true, uniqueness: true
end
