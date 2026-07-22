# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# The public library: browse and search the books, and open one book's page.
# World-readable — the only access control is the download gate on the book
# page (Magic::Listing#accessible_to?), never the listing's discoverability, so
# a protected title still appears in browse and search.
class BooksController < ApplicationController
  allow_unauthenticated_access

  # GET / and GET /books
  def index
    @query = params[:q]
    @listings = Magic::Listing.browsable.with_book_details.matching(@query)
  end

  # GET /books/:id
  def show
    @listing = Magic::Listing.with_book_details.find(params.expect(:id))
    @determination = Copyright::Determination.find_by(work_id: @listing.work_id, manifestation_id: nil)
    @project = Workflow::Project.find_by(work_id: @listing.work_id)
  end
end
