# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class AddNameToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string
  end
end
