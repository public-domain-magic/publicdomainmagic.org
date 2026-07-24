# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR (WEMI): a distinct intellectual or artistic creation. Abstract; it
# exists only in the commonality of content among its expressions.
class Catalog::Work < ApplicationRecord
  # Optional: at discovery a work's form may not be known yet. A null form is
  # honest; the record is enriched later.
  belongs_to :form_of_work, optional: true

  has_many :expressions, dependent: :destroy
  has_many :external_references, dependent: :destroy
  has_and_belongs_to_many :intended_audiences, join_table: "catalog_intended_audiences_works"

  has_many :contributions, as: :contributable, dependent: :destroy
  has_many :agents, through: :contributions

  has_many :work_relationships, dependent: :destroy
  has_many :related_works, through: :work_relationships, source: :related_work
  has_many :inverse_work_relationships, class_name: "Catalog::WorkRelationship",
    foreign_key: :related_work_id, dependent: :destroy
  has_many :relating_works, through: :inverse_work_relationships, source: :work

  has_many :subjects, dependent: :destroy
  has_many :concepts, through: :subjects, source: :subject, source_type: "Catalog::Concept"

  validates :title, presence: true
end
