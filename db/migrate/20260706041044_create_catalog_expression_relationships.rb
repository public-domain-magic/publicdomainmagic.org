# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCatalogExpressionRelationships < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_expression_relationships do |t|
      t.references :expression, null: false, foreign_key: { to_table: :catalog_expressions }
      t.references :related_expression, null: false, foreign_key: { to_table: :catalog_expressions },
        index: { name: "index_catalog_expr_relationships_on_related_expression_id" }
      t.string :kind, null: false

      t.timestamps

      t.index %i[expression_id related_expression_id kind], unique: true, name: "index_catalog_expression_relationships_uniqueness"
    end
  end
end
