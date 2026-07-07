# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Catalog administration for the controlled forms an expression may take (spoken word, notated music, and the like).
class Catalog::FormOfExpressionsController < ApplicationController
  before_action :set_catalog_form_of_expression, only: %i[show edit update destroy]

  # GET /catalog/form_of_expressions or /catalog/form_of_expressions.json
  def index
    @catalog_form_of_expressions = Catalog::FormOfExpression.all
  end

  # GET /catalog/form_of_expressions/1 or /catalog/form_of_expressions/1.json
  def show
  end

  # GET /catalog/form_of_expressions/new
  def new
    @catalog_form_of_expression = Catalog::FormOfExpression.new
  end

  # GET /catalog/form_of_expressions/1/edit
  def edit
  end

  # POST /catalog/form_of_expressions or /catalog/form_of_expressions.json
  def create
    @catalog_form_of_expression = Catalog::FormOfExpression.new(catalog_form_of_expression_params)

    respond_to do |format|
      if @catalog_form_of_expression.save
        format.html { redirect_to @catalog_form_of_expression, notice: "Form of expression was successfully created." }
        format.json { render :show, status: :created, location: @catalog_form_of_expression }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @catalog_form_of_expression.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /catalog/form_of_expressions/1 or /catalog/form_of_expressions/1.json
  def update
    respond_to do |format|
      if @catalog_form_of_expression.update(catalog_form_of_expression_params)
        format.html { redirect_to @catalog_form_of_expression, notice: "Form of expression was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @catalog_form_of_expression }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @catalog_form_of_expression.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /catalog/form_of_expressions/1 or /catalog/form_of_expressions/1.json
  def destroy
    @catalog_form_of_expression.destroy!

    respond_to do |format|
      format.html { redirect_to catalog_form_of_expressions_path, notice: "Form of expression was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  private def set_catalog_form_of_expression
    @catalog_form_of_expression = Catalog::FormOfExpression.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  private def catalog_form_of_expression_params
    params.expect(catalog_form_of_expression: [:name])
  end
end
