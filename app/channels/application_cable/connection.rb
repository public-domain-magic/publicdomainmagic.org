# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

module ApplicationCable
  # Authenticates the WebSocket off the same signed session-token cookie the
  # HTTP controllers use, so one auth surface covers both and logging out kills
  # the socket's user.
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    # Identify the socket by resolving the session cookie to a user, rejecting
    # the connection when no valid session is present.
    def connect
      set_current_user || reject_unauthorized_connection
    end

    private
      def set_current_user
        if session = Session.find_by(token: cookies.signed[:session_token])
          self.current_user = session.user
        end
      end
  end
end
