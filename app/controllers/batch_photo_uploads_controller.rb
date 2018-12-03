class BatchPhotoUploadsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_batch_photo_upload, only: [:show, :edit, :update, :destroy]
  before_action :set_collection

  # GET /batch_photo_uploads
  # GET /batch_photo_uploads.json
  def index
    redirect_to collection_import_collections_path(@collection)
  end

  def match_works
    @batch_photo_upload = BatchPhotoUpload.find(params[:batch_photo_upload_id])

    CouplePhotosJob.perform_now(@batch_photo_upload)
    redirect_to collection_works_path(@collection), notice: "De foto's worden op de achtergrond aan de werken gekoppeld (dit kan enige tijd duren)."
  end

  # GET /batch_photo_uploads/1
  # GET /batch_photo_uploads/1.json
  def show
    @page = params[:page].to_i
  end

  # GET /batch_photo_uploads/new
  def new
    @batch_photo_upload = BatchPhotoUpload.new
  end

  # GET /batch_photo_uploads/1/edit
  def edit
  end

  # POST /batch_photo_uploads
  # POST /batch_photo_uploads.json
  def create
    @batch_photo_upload = BatchPhotoUpload.new(batch_photo_upload_params)
    @batch_photo_upload.collection = @collection
    respond_to do |format|
      if @batch_photo_upload.save
        format.html { redirect_to collection_batch_photo_upload_path(@collection,@batch_photo_upload), notice: 'Batch photo upload was successfully created.' }
        format.json { render :show, status: :created, location: collection_batch_photo_upload_path(@collection,@batch_photo_upload) }
      else
        format.html { render :new }
        format.json { render json: @batch_photo_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /batch_photo_uploads/1
  # PATCH/PUT /batch_photo_uploads/1.json
  def update
    respond_to do |format|
      if @batch_photo_upload.update(batch_photo_upload_params)
        format.html { redirect_to collection_batch_photo_upload_path(@collection,@batch_photo_upload), notice: 'Batch photo upload was successfully updated.' }
        format.json { render :show, status: :ok, location: collection_batch_photo_upload_path(@collection,@batch_photo_upload) }
      else
        format.html { render :edit }
        format.json { render json: @batch_photo_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /batch_photo_uploads/1
  # DELETE /batch_photo_uploads/1.json
  def destroy
    @batch_photo_upload.destroy
    respond_to do |format|
      format.html { redirect_to collection_batch_photo_uploads_path(@collection), notice: 'Batch photo upload was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batch_photo_upload
      @batch_photo_upload = BatchPhotoUpload.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def batch_photo_upload_params
      params.require(:batch_photo_upload).permit(:zip_file, :column, {images: []})
    end
end
