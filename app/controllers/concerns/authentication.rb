# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Fail-closed authentication: every controller requires a signed-in user
# unless it opts out with +allow_unauthenticated_access+. The opaque session
# token travels in a signed, http-only cookie; the {Session} row it names sets
# +Current.session+, from which +Current.user+ derives.
module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication # steep:ignore NoMethod
    helper_method :authenticated? # steep:ignore NoMethod
  end

  class_methods do
    # Exempt the given actions from requiring a signed-in user (e.g. the
    # sign-in and first-run pages).
    def allow_unauthenticated_access(**) # steep:ignore
      skip_before_action(:require_authentication, **) # steep:ignore NoMethod
    end
  end

  private def authenticated?
    resume_session
  end

  private def require_authentication
    resume_session || request_authentication
  end

  private def resume_session
    Current.session ||= find_session_by_cookie
  end

  private def find_session_by_cookie
    Session.find_by(token: cookies.signed[:session_token]) if cookies.signed[:session_token]
  end

  private def request_authentication
    session[:return_to_after_authenticating] = request.url
    redirect_to new_session_path
  end

  private def after_authentication_url
    session.delete(:return_to_after_authenticating) || root_url
  end

  private def start_new_session_for(user)
    user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
      Current.session = session
      cookies.signed.permanent[:session_token] = { value: session.token, httponly: true, same_site: :lax }
    end
  end

  private def terminate_session
    Current.session&.destroy
    cookies.delete(:session_token)
  end
end
