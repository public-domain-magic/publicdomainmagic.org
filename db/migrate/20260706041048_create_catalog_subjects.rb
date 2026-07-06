# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCatalogSubjects < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_subjects do |t|
      t.references :work, null: false, foreign_key: { to_table: :catalog_works }
      t.references :subject, polymorphic: true, null: false

      t.timestamps

      t.index %i[work_id subject_type subject_id], unique: true, name: "index_catalog_subjects_uniqueness"
    end
  end
end
