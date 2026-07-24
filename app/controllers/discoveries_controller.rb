# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Recording a discovered book — the first librarian write surface. A discovery
# is a single guided form that materializes the whole FRBR graph across the
# contexts; the controller just translates HTTP into one +Discovery#save+.
class DiscoveriesController < ApplicationController
  include LibrarianAccess

  # GET /discoveries/new
  def new
    @discovery = Discovery.new.prefill
  end

  # POST /discoveries
  def create
    @discovery = Discovery.new(discovery_params)

    if @discovery.save
      redirect_to book_path(@discovery.listing), notice: "Discovery recorded.", status: :see_other
    else
      render :new, status: :unprocessable_content
    end
  end

  private def discovery_params
    author_names = [] #: Array[untyped]
    found_copies = [[:url, :source, :statement_of_responsibility, :content, :reproduction_of_manifestation_id]]
    references = [[:url, :source, :note]]
    params.expect(discovery: [
      :title,
      :date,
      :first_publication_year,
      :first_publication_country,
      :form_of_work_id,
      :exposure,
      :notes,
      { author_names:, found_copies_attributes: found_copies, external_references_attributes: references },
    ])
  end
end
