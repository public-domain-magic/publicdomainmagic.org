# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCatalogAgents < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_agents do |t|
      t.string :name, null: false
      t.string :kind, null: false
      t.string :birth_date
      t.string :death_date

      t.timestamps
    end
  end
end
