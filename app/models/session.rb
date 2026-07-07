# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# One authenticated session, persisted as a row so it is revocable and
# auditable. The signed cookie carries only the opaque +token+; the token
# names this row, which also records the +user_agent+ and +ip_address+ of the
# request that created it. Deleting the row signs the device out on its next
# request.
class Session < ApplicationRecord
  belongs_to :user

  has_secure_token
end
