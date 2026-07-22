# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Catalog administration for intended-audience descriptors for works.
class Catalog::IntendedAudiencesController < ApplicationController
  include LibrarianAccess
  before_action :set_catalog_intended_audience, only: %i[show edit update destroy]

  # GET /catalog/intended_audiences or /catalog/intended_audiences.json
  def index
    @catalog_intended_audiences = Catalog::IntendedAudience.all
  end

  # GET /catalog/intended_audiences/1 or /catalog/intended_audiences/1.json
  def show
  end

  # GET /catalog/intended_audiences/new
  def new
    @catalog_intended_audience = Catalog::IntendedAudience.new
  end

  # GET /catalog/intended_audiences/1/edit
  def edit
  end

  # POST /catalog/intended_audiences or /catalog/intended_audiences.json
  def create
    @catalog_intended_audience = Catalog::IntendedAudience.new(catalog_intended_audience_params)

    respond_to do |format|
      if @catalog_intended_audience.save
        format.html { redirect_to @catalog_intended_audience, notice: "Intended audience was successfully created." }
        format.json { render :show, status: :created, location: @catalog_intended_audience }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @catalog_intended_audience.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /catalog/intended_audiences/1 or /catalog/intended_audiences/1.json
  def update
    respond_to do |format|
      if @catalog_intended_audience.update(catalog_intended_audience_params)
        format.html { redirect_to @catalog_intended_audience, notice: "Intended audience was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @catalog_intended_audience }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @catalog_intended_audience.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /catalog/intended_audiences/1 or /catalog/intended_audiences/1.json
  def destroy
    @catalog_intended_audience.destroy!

    respond_to do |format|
      format.html { redirect_to catalog_intended_audiences_path, notice: "Intended audience was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  private def set_catalog_intended_audience
    @catalog_intended_audience = Catalog::IntendedAudience.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  private def catalog_intended_audience_params
    params.expect(catalog_intended_audience: [:name])
  end
end
