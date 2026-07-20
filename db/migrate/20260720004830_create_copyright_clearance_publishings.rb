# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCopyrightClearancePublishings < ActiveRecord::Migration[8.1]
  def change
    create_table :copyright_clearance_publishings do |t|
      t.references :clearance, null: false, foreign_key: { to_table: :copyright_clearances }
      t.integer :position
      t.string :year
      t.string :kind, null: false

      t.timestamps
    end
  end
end
