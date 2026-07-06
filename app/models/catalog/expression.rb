# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR (WEMI): the intellectual or artistic realization of a work — the
# specific words, sounds, or images, excluding physical form.
class Catalog::Expression < ApplicationRecord
  belongs_to :work
  belongs_to :language
  belongs_to :form_of_expression

  has_many :embodiments, dependent: :destroy
  has_many :manifestations, through: :embodiments

  has_many :contributions, as: :contributable, dependent: :destroy
  has_many :agents, through: :contributions

  has_many :expression_relationships, dependent: :destroy
  has_many :related_expressions, through: :expression_relationships, source: :related_expression
  has_many :inverse_expression_relationships, class_name: "Catalog::ExpressionRelationship",
    foreign_key: :related_expression_id, dependent: :destroy
  has_many :relating_expressions, through: :inverse_expression_relationships, source: :expression
end
