# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR Group 3: a concept that can be the subject of a work (an area of
# knowledge, a discipline, an idea).
class Catalog::Concept < ApplicationRecord
  has_many :subjects, as: :subject, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
