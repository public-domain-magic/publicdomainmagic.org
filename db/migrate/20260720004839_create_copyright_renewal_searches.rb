# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCopyrightRenewalSearches < ActiveRecord::Migration[8.1]
  def change
    create_table :copyright_renewal_searches do |t|
      t.references :investigation, null: false, foreign_key: { to_table: :copyright_investigations }
      t.string :resource
      t.string :terms
      t.date :searched_on
      t.string :status, null: false
      t.text :outcome

      t.timestamps
    end
  end
end
