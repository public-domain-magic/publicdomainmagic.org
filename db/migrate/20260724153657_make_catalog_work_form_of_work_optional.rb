# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# At discovery a work's form may be unknown; a null form of work is honest,
# better than a fabricated "Unknown" sentinel row.
class MakeCatalogWorkFormOfWorkOptional < ActiveRecord::Migration[8.1]
  def change
    change_column_null :catalog_works, :form_of_work_id, true
  end
end
