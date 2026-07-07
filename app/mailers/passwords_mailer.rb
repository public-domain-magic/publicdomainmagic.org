# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Delivers the password-reset email whose link carries the recipient's signed,
# time-boxed reset token.
class PasswordsMailer < ApplicationMailer
  # Build the reset email for +user+.
  def reset(user)
    @user = user
    mail subject: "Reset your password", to: user.email_address
  end
end
