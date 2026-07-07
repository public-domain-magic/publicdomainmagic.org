# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Catalog administration for the languages an expression is realized in.
class Catalog::LanguagesController < ApplicationController
  before_action :set_catalog_language, only: %i[show edit update destroy]

  # GET /catalog/languages or /catalog/languages.json
  def index
    @catalog_languages = Catalog::Language.all
  end

  # GET /catalog/languages/1 or /catalog/languages/1.json
  def show
  end

  # GET /catalog/languages/new
  def new
    @catalog_language = Catalog::Language.new
  end

  # GET /catalog/languages/1/edit
  def edit
  end

  # POST /catalog/languages or /catalog/languages.json
  def create
    @catalog_language = Catalog::Language.new(catalog_language_params)

    respond_to do |format|
      if @catalog_language.save
        format.html { redirect_to @catalog_language, notice: "Language was successfully created." }
        format.json { render :show, status: :created, location: @catalog_language }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @catalog_language.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /catalog/languages/1 or /catalog/languages/1.json
  def update
    respond_to do |format|
      if @catalog_language.update(catalog_language_params)
        format.html { redirect_to @catalog_language, notice: "Language was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @catalog_language }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @catalog_language.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /catalog/languages/1 or /catalog/languages/1.json
  def destroy
    @catalog_language.destroy!

    respond_to do |format|
      format.html { redirect_to catalog_languages_path, notice: "Language was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  private def set_catalog_language
    @catalog_language = Catalog::Language.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  private def catalog_language_params
    params.expect(catalog_language: [:name, :code])
  end
end
