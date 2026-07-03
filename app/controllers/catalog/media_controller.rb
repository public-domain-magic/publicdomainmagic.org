class Catalog::MediaController < ApplicationController
  before_action :set_catalog_medium, only: %i[ show edit update destroy ]

  # GET /catalog/media or /catalog/media.json
  def index
    @catalog_media = Catalog::Medium.all
  end

  # GET /catalog/media/1 or /catalog/media/1.json
  def show
  end

  # GET /catalog/media/new
  def new
    @catalog_medium = Catalog::Medium.new
  end

  # GET /catalog/media/1/edit
  def edit
  end

  # POST /catalog/media or /catalog/media.json
  def create
    @catalog_medium = Catalog::Medium.new(catalog_medium_params)

    respond_to do |format|
      if @catalog_medium.save
        format.html { redirect_to @catalog_medium, notice: "Medium was successfully created." }
        format.json { render :show, status: :created, location: @catalog_medium }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @catalog_medium.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /catalog/media/1 or /catalog/media/1.json
  def update
    respond_to do |format|
      if @catalog_medium.update(catalog_medium_params)
        format.html { redirect_to @catalog_medium, notice: "Medium was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @catalog_medium }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @catalog_medium.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /catalog/media/1 or /catalog/media/1.json
  def destroy
    @catalog_medium.destroy!

    respond_to do |format|
      format.html { redirect_to catalog_media_path, notice: "Medium was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_medium
      @catalog_medium = Catalog::Medium.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def catalog_medium_params
      params.expect(catalog_medium: [ :name ])
    end
end
