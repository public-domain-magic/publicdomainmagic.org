# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Bootstraps the very first account. Before any user exists there is nobody to
# authorize account creation, so this flow runs unauthenticated and disables
# itself the moment the users table is populated. The account it creates is
# granted every role — the founder wears all hats at launch — and signed in.
class FirstRunsController < ApplicationController
  allow_unauthenticated_access
  before_action :prevent_running_after_setup

  # GET /first_run/new
  def new
    @user = User.new
  end

  # POST /first_run
  def create
    @user = User.new(user_params)

    if @user.save
      @user.grant_founding_roles
      start_new_session_for @user
      redirect_to after_authentication_url
    else
      render :new, status: :unprocessable_content
    end
  end

  private def prevent_running_after_setup
    redirect_to root_url if User.any?
  end

  private def user_params
    params.expect(user: %i[name email_address password password_confirmation])
  end
end
