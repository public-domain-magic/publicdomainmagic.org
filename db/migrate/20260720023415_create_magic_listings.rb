# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateMagicListings < ActiveRecord::Migration[8.1]
  def change
    create_table :magic_listings do |t|
      t.references :work, null: false, index: { unique: true },
        foreign_key: { to_table: :catalog_works }
      t.string :exposure, null: false, default: "public"
      t.boolean :featured, null: false, default: false
      t.text :blurb

      t.timestamps
    end
  end
end
