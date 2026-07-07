# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR table 5.3: a typed, directed relationship between two expressions of the
# same work — one derived from another without becoming a new work.
class Catalog::ExpressionRelationship < ApplicationRecord
  # The closed vocabulary of expression-to-expression relationship kinds
  # (FRBR table 5.3).
  KINDS = %w[abridgement revision translation arrangement part].freeze

  belongs_to :expression
  belongs_to :related_expression, class_name: "Catalog::Expression"

  enum :kind, KINDS.index_by(&:itself), validate: true

  validates :kind, uniqueness: { scope: %i[expression_id related_expression_id] }
end
