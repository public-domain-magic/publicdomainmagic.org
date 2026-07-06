# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCatalogWorkRelationships < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_work_relationships do |t|
      t.references :work, null: false, foreign_key: { to_table: :catalog_works }
      t.references :related_work, null: false, foreign_key: { to_table: :catalog_works }
      t.string :kind, null: false

      t.timestamps

      t.index %i[work_id related_work_id kind], unique: true, name: "index_catalog_work_relationships_uniqueness"
    end
  end
end
