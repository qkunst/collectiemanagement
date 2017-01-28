class AttachmentsController < ApplicationController
  before_action :authenticate_qkunst_user!
  before_action :set_collection
  before_action :set_attachment, only: [:show, :edit, :update, :destroy]

  # GET /attachments
  # GET /attachments.json
  def index
    @attachments = Attachment.all
  end

  # GET /attachments/new
  def new
    @attachment = Attachment.new()
    @attachment.attache = @collection
    @attachment.visibility = ["readonly", "facility", "qkunst", "appraiser"]
  end

  # GET /attachments/1/edit
  def edit
  end

  # POST /attachments
  # POST /attachments.json
  def create
    @attachment = Attachment.new(attachment_params)
    @attachment.attache = @collection # TODO: in future this may change

    respond_to do |format|
      if @attachment.save
        format.html { redirect_to @attachment.attache, notice: 'Attachment toegevoegd' }
        format.json { render :show, status: :created, location: @attachment.attache }
      else
        format.html { render :new }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attachments/1
  # PATCH/PUT /attachments/1.json
  def update
    respond_to do |format|
      if @attachment.update(attachment_params)
        format.html { redirect_to @attachment.attache, notice: 'Attachment bijgewerkt' }
        format.json { render :show, status: :ok, location: @attachment.attache }
      else
        format.html { render :edit }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    @attachment.destroy
    respond_to do |format|
      format.html { redirect_to @collection, notice: 'Attachment verwijderd' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attachment
      @attachment = Attachment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attachment_params
      params.require(:attachment).permit(:name, :file, visibility: [])
    end
end
