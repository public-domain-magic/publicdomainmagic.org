# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Signing in and out. +new+/+create+ are reachable while logged out;
# +authenticate_by+ runs bcrypt even for unknown emails so response time does
# not reveal whether an account exists.
class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  before_action :redirect_to_first_run, only: :new
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  # GET /session/new
  def new
  end

  # POST /session
  def create
    if (user = User.authenticate_by(params.permit(:email_address, :password)))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  # DELETE /session
  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end

  private def redirect_to_first_run
    redirect_to new_first_run_url if User.none?
  end
end
