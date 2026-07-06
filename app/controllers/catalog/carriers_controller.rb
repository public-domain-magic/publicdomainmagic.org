class Catalog::CarriersController < ApplicationController
  before_action :set_catalog_carrier, only: %i[ show edit update destroy ]

  # GET /catalog/carriers or /catalog/carriers.json
  def index
    @catalog_carriers = Catalog::Carrier.all
  end

  # GET /catalog/carriers/1 or /catalog/carriers/1.json
  def show
  end

  # GET /catalog/carriers/new
  def new
    @catalog_carrier = Catalog::Carrier.new
  end

  # GET /catalog/carriers/1/edit
  def edit
  end

  # POST /catalog/carriers or /catalog/carriers.json
  def create
    @catalog_carrier = Catalog::Carrier.new(catalog_carrier_params)

    respond_to do |format|
      if @catalog_carrier.save
        format.html { redirect_to @catalog_carrier, notice: "Carrier was successfully created." }
        format.json { render :show, status: :created, location: @catalog_carrier }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @catalog_carrier.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /catalog/carriers/1 or /catalog/carriers/1.json
  def update
    respond_to do |format|
      if @catalog_carrier.update(catalog_carrier_params)
        format.html { redirect_to @catalog_carrier, notice: "Carrier was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @catalog_carrier }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @catalog_carrier.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /catalog/carriers/1 or /catalog/carriers/1.json
  def destroy
    @catalog_carrier.destroy!

    respond_to do |format|
      format.html { redirect_to catalog_carriers_path, notice: "Carrier was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_carrier
      @catalog_carrier = Catalog::Carrier.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def catalog_carrier_params
      params.expect(catalog_carrier: [ :name ])
    end
end
