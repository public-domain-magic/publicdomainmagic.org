# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCopyrightRepublications < ActiveRecord::Migration[8.1]
  def change
    create_table :copyright_republications do |t|
      t.references :investigation, null: false, foreign_key: { to_table: :copyright_investigations }
      t.string :title
      t.string :year
      t.string :publisher
      t.string :edition_designation
      # Nullable: an edition's accessibility may not have been assessed yet.
      t.string :access_status
      t.text :notes

      t.timestamps
    end
  end
end
