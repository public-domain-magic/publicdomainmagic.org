# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR (WEMI): the physical or digital embodiment of an expression of a work —
# all copies sharing the same intellectual content and production form. A
# manifestation embodying multiple expressions is an aggregate.
class Catalog::Manifestation < ApplicationRecord
  belongs_to :carrier
  belongs_to :series, optional: true

  has_many :embodiments, -> { order(:position) }, dependent: :destroy
  has_many :expressions, through: :embodiments

  has_many :items, dependent: :destroy

  has_many :contributions, as: :contributable, dependent: :destroy
  has_many :agents, through: :contributions

  has_many :manifestation_relationships, dependent: :destroy
  has_many :related_manifestations, through: :manifestation_relationships, source: :related_manifestation
  has_many :inverse_manifestation_relationships, class_name: "Catalog::ManifestationRelationship",
    foreign_key: :related_manifestation_id, dependent: :destroy
  has_many :relating_manifestations, through: :inverse_manifestation_relationships, source: :manifestation
end
