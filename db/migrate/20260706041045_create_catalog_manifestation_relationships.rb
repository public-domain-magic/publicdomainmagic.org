# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCatalogManifestationRelationships < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_manifestation_relationships do |t|
      t.references :manifestation, null: false, foreign_key: { to_table: :catalog_manifestations },
        index: { name: "index_catalog_manif_relationships_on_manifestation_id" }
      t.references :related_manifestation, null: false, foreign_key: { to_table: :catalog_manifestations },
        index: { name: "index_catalog_manif_relationships_on_related_manif_id" }
      t.string :kind, null: false

      t.timestamps

      t.index %i[manifestation_id related_manifestation_id kind], unique: true, name: "index_catalog_manifestation_relationships_uniqueness"
    end
  end
end
