# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class RenameIntendedAudiencesWorksJoinTable < ActiveRecord::Migration[8.1]
  def change
    rename_table :intended_audiences_works, :catalog_intended_audiences_works
  end
end
