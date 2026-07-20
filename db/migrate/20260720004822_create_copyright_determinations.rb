# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCopyrightDeterminations < ActiveRecord::Migration[8.1]
  def change
    create_table :copyright_determinations do |t|
      t.references :work, null: false, foreign_key: { to_table: :catalog_works }
      # NULL = the original text as first published; present = that edition's
      # added authorship (its own USCO work with its own clock).
      t.references :manifestation, foreign_key: { to_table: :catalog_manifestations }
      t.string :status, null: false
      t.string :basis
      t.string :first_publication_year
      t.string :first_publication_country
      t.string :initial_registration_number
      t.date :public_domain_on
      t.text :notes

      t.timestamps

      t.index %i[work_id manifestation_id], unique: true,
        name: "index_copyright_determinations_uniqueness"
      # SQLite treats NULLs as distinct in ordinary unique indexes, so a partial
      # index is required to enforce one unscoped determination per work.
      t.index :work_id, unique: true, where: "manifestation_id IS NULL",
        name: "index_copyright_determinations_unscoped_uniqueness"
    end
  end
end
