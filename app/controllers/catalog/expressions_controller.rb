class Catalog::ExpressionsController < ApplicationController
  before_action :set_catalog_expression, only: %i[ show edit update destroy ]

  # GET /catalog/expressions or /catalog/expressions.json
  def index
    @catalog_expressions = Catalog::Expression.all
  end

  # GET /catalog/expressions/1 or /catalog/expressions/1.json
  def show
  end

  # GET /catalog/expressions/new
  def new
    @catalog_expression = Catalog::Expression.new
  end

  # GET /catalog/expressions/1/edit
  def edit
  end

  # POST /catalog/expressions or /catalog/expressions.json
  def create
    @catalog_expression = Catalog::Expression.new(catalog_expression_params)

    respond_to do |format|
      if @catalog_expression.save
        format.html { redirect_to @catalog_expression, notice: "Expression was successfully created." }
        format.json { render :show, status: :created, location: @catalog_expression }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @catalog_expression.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /catalog/expressions/1 or /catalog/expressions/1.json
  def update
    respond_to do |format|
      if @catalog_expression.update(catalog_expression_params)
        format.html { redirect_to @catalog_expression, notice: "Expression was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @catalog_expression }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @catalog_expression.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /catalog/expressions/1 or /catalog/expressions/1.json
  def destroy
    @catalog_expression.destroy!

    respond_to do |format|
      format.html { redirect_to catalog_expressions_path, notice: "Expression was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_expression
      @catalog_expression = Catalog::Expression.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def catalog_expression_params
      params.expect(catalog_expression: [ :title, :date, :identifier, :summary, :form_of_expression_id, :language_id, :work_id ])
    end
end
