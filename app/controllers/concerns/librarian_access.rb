# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Restricts a controller to Librarians. Cataloguing is a back-office
# capability, distinct from the world-readable public library. Callers ask the
# capability (+can_catalog?+), never a role, per the auth skill; a visitor
# without it gets +403 Forbidden+ rather than a hint that the resource exists.
module LibrarianAccess
  extend ActiveSupport::Concern

  included do
    before_action :ensure_can_catalog # steep:ignore NoMethod
  end

  private def ensure_can_catalog
    head :forbidden unless Current.user&.can_catalog?
  end
end
