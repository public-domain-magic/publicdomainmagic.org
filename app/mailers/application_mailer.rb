# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Base class for all mailers. Shared delivery settings and
# layout configuration belong here.
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
