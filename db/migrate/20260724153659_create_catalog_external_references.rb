# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# A third-party record *about* a work (Conjuring Archive, Magicpedia, a dealer
# page): evidence and an existence attestation, not the book itself. Distinct
# from a Catalog edition (which is the work digitized) and promotable to a
# Copyright citation when an investigation later cites it.
class CreateCatalogExternalReferences < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_external_references do |t|
      t.references :work, null: false, foreign_key: { to_table: :catalog_works }
      t.string :url, null: false
      t.string :source
      t.text :note

      t.timestamps

      t.index %i[work_id url], unique: true,
        name: "index_catalog_external_references_uniqueness"
    end
  end
end
