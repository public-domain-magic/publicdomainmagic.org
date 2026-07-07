# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Catalog administration for the controlled forms a work may take (novel, poem, treatise, and the like).
class Catalog::FormOfWorksController < ApplicationController
  before_action :set_catalog_form_of_work, only: %i[show edit update destroy]

  # GET /catalog/form_of_works or /catalog/form_of_works.json
  def index
    @catalog_form_of_works = Catalog::FormOfWork.all
  end

  # GET /catalog/form_of_works/1 or /catalog/form_of_works/1.json
  def show
  end

  # GET /catalog/form_of_works/new
  def new
    @catalog_form_of_work = Catalog::FormOfWork.new
  end

  # GET /catalog/form_of_works/1/edit
  def edit
  end

  # POST /catalog/form_of_works or /catalog/form_of_works.json
  def create
    @catalog_form_of_work = Catalog::FormOfWork.new(catalog_form_of_work_params)

    respond_to do |format|
      if @catalog_form_of_work.save
        format.html { redirect_to @catalog_form_of_work, notice: "Form of work was successfully created." }
        format.json { render :show, status: :created, location: @catalog_form_of_work }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @catalog_form_of_work.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /catalog/form_of_works/1 or /catalog/form_of_works/1.json
  def update
    respond_to do |format|
      if @catalog_form_of_work.update(catalog_form_of_work_params)
        format.html { redirect_to @catalog_form_of_work, notice: "Form of work was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @catalog_form_of_work }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @catalog_form_of_work.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /catalog/form_of_works/1 or /catalog/form_of_works/1.json
  def destroy
    @catalog_form_of_work.destroy!

    respond_to do |format|
      format.html { redirect_to catalog_form_of_works_path, notice: "Form of work was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  private def set_catalog_form_of_work
    @catalog_form_of_work = Catalog::FormOfWork.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  private def catalog_form_of_work_params
    params.expect(catalog_form_of_work: [:name])
  end
end
