# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCatalogContributions < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_contributions do |t|
      t.references :agent, null: false, foreign_key: { to_table: :catalog_agents }
      t.references :contributable, polymorphic: true, null: false
      t.string :role, null: false

      t.timestamps
    end
  end
end
