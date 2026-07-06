# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCatalogConcepts < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_concepts do |t|
      t.string :name, null: false

      t.timestamps

      t.index :name, unique: true
    end
  end
end
