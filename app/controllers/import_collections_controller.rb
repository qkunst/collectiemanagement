class ImportCollectionsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_import_collection, only: [:show, :edit, :update, :destroy, :preview, :import_works, :delete_works]
  before_action :set_collection

  # GET /import_collections
  # GET /import_collections.json
  def index
    @import_collections = @collection.import_collections.all
    @batch_photo_uploads = @collection.batch_photo_uploads #BatchPhotoUpload.all

  end

  # GET /import_collections/1
  # GET /import_collections/1.json
  def show
  end

  # GET /import_collections/new
  def new
    @import_collection = ImportCollection.new
  end

  # GET /import_collections/1/edit
  def edit
  end

  def preview
    @selection ||= {}
    @selection[:display] = :complete
    @works = @import_collection.read
  end

  # POST /import_collections
  # POST /import_collections.json
  def create
    @import_collection = ImportCollection.new(import_collection_params)
    @import_collection.collection = @collection
    respond_to do |format|
      if @import_collection.save
        format.html { redirect_to edit_collection_import_collection_path(@collection, @import_collection), notice: 'Het importbestand is aangemaakt' }
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
    import_settings = params.require(:import_settings)
    respond_to do |format|
      if @import_collection.update(import_collection_params.merge(import_settings: import_settings))
        format.html { redirect_to collection_import_collection_preview_path(@collection, @import_collection), notice: 'Import collection was successfully updated.' }
        format.json { render :show, status: :ok, location: @import_collection }
      else
        format.html { render :edit }
        format.json { render json: @import_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def import_works
    delete_works({redirect: false})
    @import_collection.write
    redirect_to collection_works_path(@collection), notice: 'De werken zijn geïmporeerd.'
  end


  def delete_works options={}
    @import_collection.works.destroy_all
    @import_collection.artists.clean!
    redirect_to collection_import_collection_path(@collection, @import_collection), notice: 'De werken die met deze importer zijn aangemaakt zijn verwijderd.' unless options[:redirect] == false
  end

  # DELETE /import_collections/1
  # DELETE /import_collections/1.json
  def destroy
    @import_collection.destroy
    respond_to do |format|
      format.html { redirect_to import_collections_url, notice: 'Import collection was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_import_collection
      @import_collection = ImportCollection.find(params[:import_collection_id]||params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def import_collection_params
      params.require(:import_collection).permit(:file, :header_row, :external_inventory, :decimal_separator)
    end
end
