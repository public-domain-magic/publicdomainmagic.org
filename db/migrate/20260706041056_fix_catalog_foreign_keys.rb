# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class FixCatalogForeignKeys < ActiveRecord::Migration[8.1]
  # The original create-table migrations used `foreign_key: true`, which derives
  # the target table from the column name and ignores table_name_prefix, so every
  # FK targets a nonexistent unprefixed table. Repair the 8 surviving broken FKs
  # (the 3 on manifestations already died in OverhaulCatalogManifestations).
  REPAIRS = {
    catalog_expressions: {
form_of_expression_id: :catalog_form_of_expressions,
language_id: :catalog_languages,
work_id: :catalog_works,
},
    catalog_items: {
condition_id: :catalog_conditions,
manifestation_id: :catalog_manifestations,
},
    catalog_manifestations: {
medium_id: :catalog_media,
series_id: :catalog_series,
},
    catalog_works: { form_of_work_id: :catalog_form_of_works },
  }.freeze

  # Runs outside a transaction so the SQLite table rebuilds behind
  # remove_foreign_key/add_foreign_key can disable FK enforcement; otherwise the
  # rebuild fails resolving the still-broken FKs on the same table.
  disable_ddl_transaction!

  def up
    REPAIRS.each do |table, columns|
      columns.each do |column, to_table|
        remove_foreign_key(table, column:)
        add_foreign_key table, to_table, column:
      end
    end
  end

  def down
    # The old foreign keys pointed at nonexistent tables; do not restore them.
  end
end
