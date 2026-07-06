# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCatalogNomens < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_nomens do |t|
      t.references :agent, null: false, foreign_key: { to_table: :catalog_agents }
      t.string :name, null: false
      t.string :kind, null: false
      t.string :note

      t.timestamps
    end
  end
end
