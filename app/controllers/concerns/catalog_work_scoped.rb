# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Shared setup for the librarian's entry-workbench actions nested beneath a
# Catalog work: the LibrarianAccess guard and loading the work the enrichment
# action hangs off. A missing id raises RecordNotFound (404).
module CatalogWorkScoped
  extend ActiveSupport::Concern

  included do
    include LibrarianAccess
    before_action :set_catalog_work # steep:ignore NoMethod
  end

  private def set_catalog_work
    @catalog_work = Catalog::Work.find(params.expect(:work_id))
  end
end
