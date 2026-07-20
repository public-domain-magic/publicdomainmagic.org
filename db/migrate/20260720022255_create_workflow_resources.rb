# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateWorkflowResources < ActiveRecord::Migration[8.1]
  def change
    create_table :workflow_resources do |t|
      t.references :project, null: false, foreign_key: { to_table: :workflow_projects }
      t.string :kind, null: false
      t.string :url, null: false
      t.string :note

      t.timestamps

      # Multiple rows per kind are allowed except the book's one text repo.
      t.index %i[project_id kind], unique: true, where: "kind = 'text_repo'",
        name: "index_workflow_resources_text_repo_uniqueness"
    end
  end
end
