# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# A third-party record *about* a work — a Conjuring Archive or Magicpedia entry,
# a dealer page — as opposed to the work digitized (that is a Catalog edition).
# It attests the work exists, anchors work identity, and is the raw material a
# Copyright citation later formalizes.
class Catalog::ExternalReference < ApplicationRecord
  belongs_to :work

  validates :url, presence: true
  validates :url, uniqueness: { scope: :work_id }
end
