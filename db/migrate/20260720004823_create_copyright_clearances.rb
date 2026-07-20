# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCopyrightClearances < ActiveRecord::Migration[8.1]
  def change
    create_table :copyright_clearances do |t|
      t.references :manifestation, null: false, foreign_key: { to_table: :catalog_manifestations }
      t.references :determination, foreign_key: { to_table: :copyright_determinations }
      t.references :researcher, null: false, foreign_key: { to_table: :users }
      t.string :status, null: false
      t.string :title
      t.string :subtitle
      t.string :language_code
      t.text :notes
      t.string :publisher_name
      t.string :publication_city
      t.string :publication_country
      t.text :source_notes
      t.text :scans_archive_urls
      t.text :wikipedia_urls
      t.string :pg_request_id
      t.string :pg_rule_applied
      t.string :pg_ok_key
      t.datetime :submitted_at
      t.datetime :cleared_at

      t.timestamps
    end
  end
end
