# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Catalog administration for FRBR Items — a single exemplar of a manifestation.
class Catalog::ItemsController < ApplicationController
  include LibrarianAccess
  before_action :set_catalog_item, only: %i[show edit update destroy]

  # GET /catalog/items or /catalog/items.json
  def index
    @catalog_items = Catalog::Item.all
  end

  # GET /catalog/items/1 or /catalog/items/1.json
  def show
  end

  # GET /catalog/items/new
  def new
    @catalog_item = Catalog::Item.new
  end

  # GET /catalog/items/1/edit
  def edit
  end

  # POST /catalog/items or /catalog/items.json
  def create
    @catalog_item = Catalog::Item.new(catalog_item_params)

    respond_to do |format|
      if @catalog_item.save
        format.html { redirect_to @catalog_item, notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @catalog_item }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @catalog_item.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /catalog/items/1 or /catalog/items/1.json
  def update
    respond_to do |format|
      if @catalog_item.update(catalog_item_params)
        format.html { redirect_to @catalog_item, notice: "Item was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @catalog_item }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @catalog_item.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /catalog/items/1 or /catalog/items/1.json
  def destroy
    @catalog_item.destroy!

    respond_to do |format|
      format.html { redirect_to catalog_items_path, notice: "Item was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  private def set_catalog_item
    @catalog_item = Catalog::Item.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  private def catalog_item_params
    params.expect(catalog_item: [:identifier, :provenance, :marks, :manifestation_id, :condition_id])
  end
end
