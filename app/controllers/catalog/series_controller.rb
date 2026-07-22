# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Catalog administration for the series that group related works.
class Catalog::SeriesController < ApplicationController
  include LibrarianAccess
  before_action :set_catalog_series, only: %i[show edit update destroy]

  # GET /catalog/series or /catalog/series.json
  def index
    @catalog_series = Catalog::Series.all
  end

  # GET /catalog/series/1 or /catalog/series/1.json
  def show
  end

  # GET /catalog/series/new
  def new
    @catalog_series = Catalog::Series.new
  end

  # GET /catalog/series/1/edit
  def edit
  end

  # POST /catalog/series or /catalog/series.json
  def create
    @catalog_series = Catalog::Series.new(catalog_series_params)

    respond_to do |format|
      if @catalog_series.save
        format.html { redirect_to @catalog_series, notice: "Series was successfully created." }
        format.json { render :show, status: :created, location: @catalog_series }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @catalog_series.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /catalog/series/1 or /catalog/series/1.json
  def update
    respond_to do |format|
      if @catalog_series.update(catalog_series_params)
        format.html { redirect_to @catalog_series, notice: "Series was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @catalog_series }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @catalog_series.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /catalog/series/1 or /catalog/series/1.json
  def destroy
    @catalog_series.destroy!

    respond_to do |format|
      format.html { redirect_to catalog_series_index_path, notice: "Series was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  private def set_catalog_series
    @catalog_series = Catalog::Series.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  private def catalog_series_params
    params.expect(catalog_series: [:name])
  end
end
