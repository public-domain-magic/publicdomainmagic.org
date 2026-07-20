# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateMagicPurchaseLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :magic_purchase_links do |t|
      t.references :listing, null: false, foreign_key: { to_table: :magic_listings }
      t.string :label, null: false
      t.string :url, null: false
      t.integer :position

      t.timestamps
    end
  end
end
