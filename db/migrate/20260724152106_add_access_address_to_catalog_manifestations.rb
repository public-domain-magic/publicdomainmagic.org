# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# The FRBR manifestation "access address" (electronic resource, remote access):
# the URL a digital edition is read at. Print editions have none; nullable.
class AddAccessAddressToCatalogManifestations < ActiveRecord::Migration[8.1]
  def change
    add_column :catalog_manifestations, :access_address, :string
  end
end
