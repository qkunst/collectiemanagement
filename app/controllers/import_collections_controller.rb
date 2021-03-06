# frozen_string_literal: true

class ImportCollectionsController < ApplicationController
  before_action :set_collection
  before_action :set_import_collection, only: [:show, :edit, :update, :destroy, :preview, :import_works, :delete_works]

  # GET /import_collections
  # GET /import_collections.json
  def index
    authorize! :index, ImportCollection
    @import_collections = @collection.import_collections.all
    @batch_photo_uploads = @collection.batch_photo_uploads # BatchPhotoUpload.all
  end

  # GET /import_collections/1
  # GET /import_collections/1.json
  def show
    authorize! :show, @import_collection
  end

  # GET /import_collections/new
  def new
    @import_collection = ImportCollection.new
    authorize! :new, @import_collection
  end

  # GET /import_collections/1/edit
  def edit
    authorize! :edit, @import_collection
  end

  def preview
    authorize! :preview, @import_collection

    begin
      @selection ||= {}
      @selection[:display] = :complete
      @works = @import_collection.read
    rescue ImportCollection::FailedImportError => error
      redirect_to collection_import_collection_path(@collection, @import_collection), alert: "Er is een fout opgetreden bij het maken van de preview, verbeter de import file: #{error.message}..."
    end
  end

  # POST /import_collections
  # POST /import_collections.json
  def create
    @import_collection = ImportCollection.new(import_collection_params)
    @import_collection.collection = @collection
    authorize! :create, @import_collection

    respond_to do |format|
      if @import_collection.save
        format.html { redirect_to edit_collection_import_collection_path(@collection, @import_collection), notice: "Het importbestand is aangemaakt" }
        format.json { render :show, status: :created, location: @import_collection }
      else
        format.html { render :new }
        format.json { render json: @import_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /import_collections/1
  # PATCH/PUT /import_collections/1.json
  def update
    authorize! :update, @import_collection

    import_settings = params.require(:import_settings).to_unsafe_h

    update_parameters = import_collection_params.to_h
    update_parameters[:import_settings] = import_settings

    respond_to do |format|
      if @import_collection.update(update_parameters)
        format.html { redirect_to collection_import_collection_preview_path(@collection, @import_collection), notice: "Import is bijgewerkt." }
        format.json { render :show, status: :ok, location: @import_collection }
      else
        format.html { render :edit }
        format.json { render json: @import_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def import_works
    authorize! :import_works, @import_collection

    delete_works({redirect: false})
    begin
      @import_collection.write
      redirect_to collection_works_path(@collection), notice: "De werken zijn geïmporeerd."
    rescue ImportCollection::FailedImportError => error
      redirect_to collection_import_collection_path(@collection, @import_collection), alert: "Er is een fout opgetreden bij het importeren, verbeter de import file: #{error.message}..."
    end
  end

  def delete_works options = {}
    authorize! :delete_works, @import_collection

    @import_collection.works.destroy_all
    @import_collection.artists.destroy_all_empty_artists!
    redirect_to collection_import_collection_path(@collection, @import_collection), notice: "De werken die met deze importer zijn aangemaakt zijn verwijderd." unless options[:redirect] == false
  end

  # DELETE /import_collections/1
  # DELETE /import_collections/1.json
  def destroy
    authorize! :destroy, @import_collection

    @import_collection.destroy
    respond_to do |format|
      format.html { redirect_to import_collections_url, notice: "Import collection was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_import_collection
    @import_collection = @collection.import_collections.find(params[:import_collection_id] || params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def import_collection_params
    params.require(:import_collection).permit(:file, :header_row, :external_inventory, :decimal_separator)
  end
end
