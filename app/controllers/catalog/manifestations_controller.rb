# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Catalog administration for FRBR Manifestations — a published embodiment of an expression.
class Catalog::ManifestationsController < ApplicationController
  include LibrarianAccess
  before_action :set_catalog_manifestation, only: %i[show edit update destroy]

  # GET /catalog/manifestations or /catalog/manifestations.json
  def index
    @catalog_manifestations = Catalog::Manifestation.all
  end

  # GET /catalog/manifestations/1 or /catalog/manifestations/1.json
  def show
  end

  # GET /catalog/manifestations/new
  def new
    @catalog_manifestation = Catalog::Manifestation.new
  end

  # GET /catalog/manifestations/1/edit
  def edit
  end

  # POST /catalog/manifestations or /catalog/manifestations.json
  def create
    @catalog_manifestation = Catalog::Manifestation.new(catalog_manifestation_params)

    respond_to do |format|
      if @catalog_manifestation.save
        format.html { redirect_to @catalog_manifestation, notice: "Manifestation was successfully created." }
        format.json { render :show, status: :created, location: @catalog_manifestation }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @catalog_manifestation.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /catalog/manifestations/1 or /catalog/manifestations/1.json
  def update
    respond_to do |format|
      if @catalog_manifestation.update(catalog_manifestation_params)
        format.html { redirect_to @catalog_manifestation, notice: "Manifestation was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @catalog_manifestation }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @catalog_manifestation.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /catalog/manifestations/1 or /catalog/manifestations/1.json
  def destroy
    @catalog_manifestation.destroy!

    respond_to do |format|
      format.html { redirect_to catalog_manifestations_path, notice: "Manifestation was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  private def set_catalog_manifestation
    @catalog_manifestation = Catalog::Manifestation.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  private def catalog_manifestation_params
    params.expect(catalog_manifestation: [:title, :statement_of_responsibility, :edition_or_issue, :date_of_publication, :place_of_publication, :identifier, :carrier_id, :series_id])
  end
end
