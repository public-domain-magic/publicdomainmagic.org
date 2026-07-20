# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCopyrightFindings < ActiveRecord::Migration[8.1]
  def change
    create_table :copyright_findings do |t|
      t.references :investigation, null: false, foreign_key: { to_table: :copyright_investigations }
      t.string :section, null: false
      t.string :question
      t.text :answer
      t.integer :position

      t.timestamps
    end
  end
end
