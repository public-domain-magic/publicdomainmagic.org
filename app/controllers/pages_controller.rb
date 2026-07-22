# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# The public marketing site: the home page and the static pages that explain
# what Public Domain Magic is, our goals, our stance on exposure, how to take
# part, and how the ebooks are licensed. All world-readable; each action just
# renders its template.
class PagesController < ApplicationController
  allow_unauthenticated_access

  # GET /
  def index
  end

  # GET /about
  def about
  end

  # GET /about/our-goals
  def about_our_goals
  end

  # GET /about/exposure
  def about_exposure
  end

  # GET /about/dual-license
  def about_dual_license
  end

  # GET /about/accessibility
  def accessibility
  end

  # GET /contribute
  def contribute
  end

  # GET /newsletter
  def newsletter
  end
end
