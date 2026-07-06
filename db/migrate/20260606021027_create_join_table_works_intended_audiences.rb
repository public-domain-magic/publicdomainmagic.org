# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

class CreateJoinTableWorksIntendedAudiences < ActiveRecord::Migration[8.1]
  def change
    create_join_table :works, :intended_audiences do |t|
      t.index [:work_id, :intended_audience_id]
      t.index [:intended_audience_id, :work_id]
    end
  end
end
