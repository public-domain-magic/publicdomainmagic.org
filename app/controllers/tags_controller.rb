# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# The books carrying one tag — a filtered view of the public library.
class TagsController < ApplicationController
  allow_unauthenticated_access

  # GET /tags/:id
  def show
    @tag = Magic::Tag.find(params.expect(:id))
    @listings = Magic::Listing.browsable.with_book_details.tagged_with(@tag)
  end
end
