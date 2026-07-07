# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Flat, public content pages. For now just the site's front door at the root
# path; siblings (about, colophon) can join as static actions. The Magic
# context (plan 005) is expected to take over the public library UI later.
class PagesController < ApplicationController
  allow_unauthenticated_access

  # GET /
  def home
  end
end
