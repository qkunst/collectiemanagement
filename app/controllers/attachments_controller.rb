# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :authenticate_qkunst_user!
  before_action :set_subject
  before_action :set_collection

  before_action :set_attachment, only: [:show, :edit, :update, :destroy]

  authorize_resource

  def index
    @attachments = if @subject
      @subject.attachments.for_me(current_user).all
    else
      @collection.attachments.for_me(current_user).all
    end
  end

  def new
    @attachment = Attachment.new
    @attachment.collection = @collection
    @attachment.works << @work if @work
    @attachment.artists << @artist if @artist
    @attachment.visibility = ["facility_manager", "compliance"]
    @attachments = @collection.attachments_including_parent_attachments.all
    @attachments -= @work.attachments if @work
  end

  def edit
  end

  def create
    @attachment = Attachment.new(attachment_params)
    @attachment.collection = @collection

    respond_to do |format|
      if @attachment.save
        @attachment.works << @work if @work
        @attachment.artists << @artist if @artist

        format.html { redirect_to redirect_url, notice: "Attachment toegevoegd" }
        format.json { render :show, status: :created, location: redirect_url }
      else
        format.html { render :new }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @attachment.update(attachment_params)
        format.html { redirect_to redirect_url, notice: "Attachment bijgewerkt" }
        format.json { render :show, status: :ok, location: redirect_url }
      else
        format.html { render :edit }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @subject
      @subject.attachments -= [@attachment]
      notice = "Attachment verwijderd bij #{I18n.t @subject.class.name.downcase, :activerecord, :models}"
    else
      notice = "Attachment volledig verwijderd"
      @attachment.destroy
    end
    respond_to do |format|
      format.html { redirect_to redirect_url, notice: notice }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_attachment
    @attachment = @collection.attachments_including_parent_attachments.find(params[:id])
  end

  def set_subject
    if params[:work_id]
      @work = current_user.accessible_works.find(params[:work_id])
    end
    if params[:artist_id]
      @artist = current_user.accessible_artists.find(params[:artist_id])
    end
    @subject = @work || @artist
  end

  def redirect_url
    if @subject
      [@collection, @subject]
    else
      @collection
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def attachment_params
    a_params = params.require(:attachment).permit(:name, :file, :file_cache, visibility: [], append_work_ids: [], append_artist_ids: [])
    a_params[:append_works] = current_user.accessible_works.where(id: a_params.delete(:append_work_ids))
    a_params[:append_artists] = current_user.accessible_artists.where(id: a_params.delete(:append_artist_ids))
    a_params
  end
end
