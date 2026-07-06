# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCatalogEmbodiments < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_embodiments do |t|
      t.references :manifestation, null: false, foreign_key: { to_table: :catalog_manifestations }
      t.references :expression, null: false, foreign_key: { to_table: :catalog_expressions }
      t.integer :position

      t.timestamps

      t.index %i[manifestation_id expression_id], unique: true, name: "index_catalog_embodiments_uniqueness"
    end
  end
end
