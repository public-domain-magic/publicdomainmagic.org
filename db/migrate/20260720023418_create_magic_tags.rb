# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateMagicTags < ActiveRecord::Migration[8.1]
  def change
    create_table :magic_tags do |t|
      t.string :name, null: false
      # Nullable: the Group 3 bridge to Catalog is a gardening activity,
      # not a requirement for tagging.
      t.references :concept, foreign_key: { to_table: :catalog_concepts }

      t.timestamps

      t.index :name, unique: true
    end
  end
end
