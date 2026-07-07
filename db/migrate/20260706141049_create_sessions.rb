# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token, null: false # opaque secret carried by the signed cookie (has_secure_token)
      t.string :ip_address
      t.string :user_agent

      t.timestamps

      t.index :token, unique: true
    end
  end
end
