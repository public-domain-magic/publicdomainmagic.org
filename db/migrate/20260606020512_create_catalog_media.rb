# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateCatalogMedia < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_media do |t|
      t.string :name

      t.timestamps
    end
  end
end
