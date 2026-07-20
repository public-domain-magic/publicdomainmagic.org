# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCopyrightAliasFindings < ActiveRecord::Migration[8.1]
  def change
    create_table :copyright_alias_findings do |t|
      t.references :author_research, null: false, foreign_key: { to_table: :copyright_author_researches }
      t.string :name
      t.string :kind, null: false
      t.string :note

      t.timestamps
    end
  end
end
