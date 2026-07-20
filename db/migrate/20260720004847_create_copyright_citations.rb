# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCopyrightCitations < ActiveRecord::Migration[8.1]
  def change
    create_table :copyright_citations do |t|
      # Polymorphic columns cannot have DB foreign keys; the model validates.
      t.references :citable, polymorphic: true, null: false
      t.string :url
      t.text :quote
      t.date :accessed_on

      t.timestamps
    end
  end
end
