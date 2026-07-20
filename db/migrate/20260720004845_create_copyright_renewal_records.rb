# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCopyrightRenewalRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :copyright_renewal_records do |t|
      t.references :renewal_search, null: false, foreign_key: { to_table: :copyright_renewal_searches }
      t.string :registration_number
      t.string :renewal_number
      t.string :holder
      # Nullable: a record may be found before its applicability is assessed.
      t.boolean :applies
      t.text :assessment

      t.timestamps
    end
  end
end
