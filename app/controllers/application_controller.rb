# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Base controller for the PublicDomainMagic application.
#
# All controllers inherit from this class. Shared filters, rescue handlers,
# and helper declarations belong here so they apply application-wide.
class ApplicationController < ActionController::Base
  include Authentication
  allow_browser versions: :modern
  stale_when_importmap_changes
end
