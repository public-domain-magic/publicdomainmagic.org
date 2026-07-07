# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Catalog administration for physical-condition descriptors for items.
class Catalog::ConditionsController < ApplicationController
  before_action :set_catalog_condition, only: %i[show edit update destroy]

  # GET /catalog/conditions or /catalog/conditions.json
  def index
    @catalog_conditions = Catalog::Condition.all
  end

  # GET /catalog/conditions/1 or /catalog/conditions/1.json
  def show
  end

  # GET /catalog/conditions/new
  def new
    @catalog_condition = Catalog::Condition.new
  end

  # GET /catalog/conditions/1/edit
  def edit
  end

  # POST /catalog/conditions or /catalog/conditions.json
  def create
    @catalog_condition = Catalog::Condition.new(catalog_condition_params)

    respond_to do |format|
      if @catalog_condition.save
        format.html { redirect_to @catalog_condition, notice: "Condition was successfully created." }
        format.json { render :show, status: :created, location: @catalog_condition }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @catalog_condition.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /catalog/conditions/1 or /catalog/conditions/1.json
  def update
    respond_to do |format|
      if @catalog_condition.update(catalog_condition_params)
        format.html { redirect_to @catalog_condition, notice: "Condition was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @catalog_condition }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @catalog_condition.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /catalog/conditions/1 or /catalog/conditions/1.json
  def destroy
    @catalog_condition.destroy!

    respond_to do |format|
      format.html { redirect_to catalog_conditions_path, notice: "Condition was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  private def set_catalog_condition
    @catalog_condition = Catalog::Condition.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  private def catalog_condition_params
    params.expect(catalog_condition: [:name])
  end
end
