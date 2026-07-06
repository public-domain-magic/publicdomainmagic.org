# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class ExpandCatalogLanguageCode < ActiveRecord::Migration[8.1]
  def up
    change_column :catalog_languages, :code, :string, limit: 3
  end

  def down
    change_column :catalog_languages, :code, :string, limit: 2
  end
end
