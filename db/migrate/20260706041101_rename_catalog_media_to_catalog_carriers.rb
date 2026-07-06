# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class RenameCatalogMediaToCatalogCarriers < ActiveRecord::Migration[8.1]
  def change
    rename_table :catalog_media, :catalog_carriers
    rename_column :catalog_manifestations, :medium_id, :carrier_id
  end
end
