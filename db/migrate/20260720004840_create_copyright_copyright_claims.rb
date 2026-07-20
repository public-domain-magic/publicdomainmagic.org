# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCopyrightCopyrightClaims < ActiveRecord::Migration[8.1]
  def change
    create_table :copyright_copyright_claims do |t|
      t.references :investigation, null: false, foreign_key: { to_table: :copyright_investigations }
      t.string :claimant_name
      t.text :basis

      t.timestamps
    end
  end
end
