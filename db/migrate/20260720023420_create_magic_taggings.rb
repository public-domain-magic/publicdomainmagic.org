# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateMagicTaggings < ActiveRecord::Migration[8.1]
  def change
    create_table :magic_taggings do |t|
      t.references :tag, null: false, foreign_key: { to_table: :magic_tags }
      # Polymorphic columns cannot have DB foreign keys; the model validates.
      t.references :taggable, polymorphic: true, null: false

      t.timestamps

      t.index %i[tag_id taggable_type taggable_id], unique: true,
        name: "index_magic_taggings_uniqueness"
    end
  end
end
