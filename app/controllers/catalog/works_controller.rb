# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Catalog administration for FRBR Works — a distinct intellectual or artistic creation.
class Catalog::WorksController < ApplicationController
  before_action :set_catalog_work, only: %i[show edit update destroy]

  # GET /catalog/works or /catalog/works.json
  def index
    @catalog_works = Catalog::Work.all
  end

  # GET /catalog/works/1 or /catalog/works/1.json
  def show
  end

  # GET /catalog/works/new
  def new
    @catalog_work = Catalog::Work.new
  end

  # GET /catalog/works/1/edit
  def edit
  end

  # POST /catalog/works or /catalog/works.json
  def create
    @catalog_work = Catalog::Work.new(catalog_work_params)

    respond_to do |format|
      if @catalog_work.save
        format.html { redirect_to @catalog_work, notice: "Work was successfully created." }
        format.json { render :show, status: :created, location: @catalog_work }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @catalog_work.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /catalog/works/1 or /catalog/works/1.json
  def update
    respond_to do |format|
      if @catalog_work.update(catalog_work_params)
        format.html { redirect_to @catalog_work, notice: "Work was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @catalog_work }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @catalog_work.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /catalog/works/1 or /catalog/works/1.json
  def destroy
    @catalog_work.destroy!

    respond_to do |format|
      format.html { redirect_to catalog_works_path, notice: "Work was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  private def set_catalog_work
    @catalog_work = Catalog::Work.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  private def catalog_work_params
    params.expect(catalog_work: [:title, :date, :identifier, :form_of_work_id])
  end
end
