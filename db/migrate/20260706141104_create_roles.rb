# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateRoles < ActiveRecord::Migration[8.1]
  def change
    create_table :roles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.references :granted_by, foreign_key: { to_table: :users } # nullable: first-run/seed grants
      t.string :note

      t.timestamps

      t.index %i[user_id name], unique: true
    end
  end
end
