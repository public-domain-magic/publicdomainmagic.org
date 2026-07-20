# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateWorkflowProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :workflow_projects do |t|
      t.references :work, null: false, index: { unique: true },
        foreign_key: { to_table: :catalog_works }
      t.references :lead, null: false, foreign_key: { to_table: :users }
      # Nullable: the PDM ebook edition this pipeline produces, once it exists.
      t.references :edition_manifestation, foreign_key: { to_table: :catalog_manifestations }
      t.text :notes

      t.timestamps
    end
  end
end
