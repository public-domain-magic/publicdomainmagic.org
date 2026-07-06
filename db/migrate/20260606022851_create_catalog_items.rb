# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCatalogItems < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_items do |t|
      t.string :identifier
      t.string :provenance
      t.string :marks
      t.references :manifestation, null: false, foreign_key: true
      t.references :condition, null: false, foreign_key: true

      t.timestamps
    end
  end
end
