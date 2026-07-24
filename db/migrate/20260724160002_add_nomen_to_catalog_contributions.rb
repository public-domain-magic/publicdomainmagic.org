# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# The optional name-as-used on a contribution: *Thavant* is bylined "Phil
# Goldstein" while *Parallax* is bylined "Max Maven", yet both collocate under
# the one agent's best name. The nomen records which of the agent's known names
# a given contribution used; display falls back to the agent's best name when
# absent.
class AddNomenToCatalogContributions < ActiveRecord::Migration[8.1]
  def change
    add_reference :catalog_contributions, :nomen,
      null: true, foreign_key: { to_table: :catalog_nomens }
  end
end
