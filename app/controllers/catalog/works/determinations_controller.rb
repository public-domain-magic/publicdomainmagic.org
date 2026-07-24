# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Recording a copyright notice on an entry: the librarian transcribes the
# first-publication/notice year (and country, registration), and the Copyright
# context computes the verdict. Create records it the first time; update
# corrects it later — both call the one intention-revealing model method.
class Catalog::Works::DeterminationsController < ApplicationController
  include CatalogWorkScoped

  # POST /catalog/works/:work_id/determination
  def create
    record_notice
  end

  # PATCH/PUT /catalog/works/:work_id/determination
  def update
    record_notice
  end

  private def record_notice
    attributes = determination_params
    Copyright::Determination.record_notice(
      work: @catalog_work,
      first_publication_year: attributes[:first_publication_year],
      first_publication_country: attributes[:first_publication_country],
      initial_registration_number: attributes[:initial_registration_number],
      notes: attributes[:notes])
    redirect_to catalog_work_path(@catalog_work),
      notice: "Copyright notice recorded.", status: :see_other
  end

  private def determination_params
    params.expect(determination: %i[
      first_publication_year first_publication_country initial_registration_number notes
])
  end
end
