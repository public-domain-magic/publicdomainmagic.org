# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCopyrightInvestigations < ActiveRecord::Migration[8.1]
  def change
    create_table :copyright_investigations do |t|
      t.references :determination, null: false, foreign_key: { to_table: :copyright_determinations }
      t.references :researcher, null: false, foreign_key: { to_table: :users }
      t.string :status, null: false

      t.timestamps
    end
  end
end
