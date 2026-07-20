# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateWorkflowSteps < ActiveRecord::Migration[8.1]
  def change
    create_table :workflow_steps do |t|
      t.references :project, null: false, foreign_key: { to_table: :workflow_projects }
      t.string :kind, null: false
      t.string :status, null: false
      # Nullable: a todo step has no actor yet.
      t.references :actor, foreign_key: { to_table: :users }
      t.date :happened_on
      t.text :note

      t.timestamps

      t.index %i[project_id kind], unique: true
    end
  end
end
