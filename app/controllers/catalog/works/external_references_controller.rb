# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Citing a third-party record *about* an entry — a Magicpedia page, a dealer
# listing, a review. Shared evidence: it attests the work and is the raw
# material a Copyright citation later formalizes.
class Catalog::Works::ExternalReferencesController < ApplicationController
  include CatalogWorkScoped

  # POST /catalog/works/:work_id/external_references
  def create
    @catalog_work.external_references.create!(external_reference_params)
    redirect_to catalog_work_path(@catalog_work),
      notice: "Reference cited.", status: :see_other
  rescue ActiveRecord::RecordInvalid => error
    redirect_to catalog_work_path(@catalog_work),
      alert: error.record.errors.full_messages.to_sentence, status: :see_other
  end

  # DELETE /catalog/works/:work_id/external_references/:id
  def destroy
    @catalog_work.external_references.find(params.expect(:id)).destroy!
    redirect_to catalog_work_path(@catalog_work),
      notice: "Reference removed.", status: :see_other
  end

  private def external_reference_params
    params.expect(external_reference: %i[url source note])
  end
end
