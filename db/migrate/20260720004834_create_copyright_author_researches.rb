# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCopyrightAuthorResearches < ActiveRecord::Migration[8.1]
  def change
    create_table :copyright_author_researches do |t|
      t.references :investigation, null: false, foreign_key: { to_table: :copyright_investigations }
      # Nullable: the researched person may not have a catalog identity yet.
      t.references :agent, foreign_key: { to_table: :catalog_agents }
      t.string :name
      t.string :role, null: false
      t.string :us_status, null: false
      t.text :basis
      t.string :birth_date
      t.string :death_date
      t.text :heirs

      t.timestamps
    end
  end
end
