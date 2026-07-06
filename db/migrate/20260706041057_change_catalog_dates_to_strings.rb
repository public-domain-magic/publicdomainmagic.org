# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class ChangeCatalogDatesToStrings < ActiveRecord::Migration[8.1]
  def up
    change_column :catalog_works, :date, :string
    change_column :catalog_expressions, :date, :string
  end

  def down
    change_column :catalog_works, :date, :date
    change_column :catalog_expressions, :date, :date
  end
end
