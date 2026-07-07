# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Request-scoped attributes, reset between requests. Controllers set the
# {Session} once (via the Authentication concern) and the current {User} falls
# out of it, so models can read +Current.user+ without controllers threading it
# down.
class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :user, to: :session, allow_nil: true
end
