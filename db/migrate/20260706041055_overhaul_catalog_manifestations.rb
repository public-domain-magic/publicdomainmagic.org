# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class OverhaulCatalogManifestations < ActiveRecord::Migration[8.1]
  # Runs outside a transaction so alter_table's built-in
  # disable_referential_integrity can turn PRAGMA foreign_keys OFF during the
  # SQLite table rebuilds. The rebuild copies rows through every surviving FK,
  # and this table still carries the latent broken FKs (medium_id -> "media",
  # series_id -> "series") that FixCatalogForeignKeys repairs next; without FK
  # enforcement off, the copy fails resolving those nonexistent tables.
  disable_ddl_transaction!

  def up
    remove_reference :catalog_manifestations, :expression
    remove_reference :catalog_manifestations, :language
    remove_reference :catalog_manifestations, :form_of_expression
    change_column_null :catalog_manifestations, :series_id, true
    add_column :catalog_manifestations, :identifier, :string
    add_column :catalog_manifestations, :place_of_publication, :string
  end

  def down
    remove_column :catalog_manifestations, :place_of_publication
    remove_column :catalog_manifestations, :identifier
    change_column_null :catalog_manifestations, :series_id, false
    add_reference :catalog_manifestations, :form_of_expression, null: false, foreign_key: { to_table: :catalog_form_of_expressions }
    add_reference :catalog_manifestations, :language, null: false, foreign_key: { to_table: :catalog_languages }
    add_reference :catalog_manifestations, :expression, null: false, foreign_key: { to_table: :catalog_expressions }
  end
end
