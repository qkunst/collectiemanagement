# frozen_string_literal: true

class MessagesController < ApplicationController
  authorize_resource

  before_action :set_work
  before_action :set_collection
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :set_new_message, only: [:show, :new, :index]

  # GET /messages
  # GET /messages.json
  def index
    messages = Message.conversation_starters.order_by_reverse_creation_date

    if subject_object
      messages = messages.for(subject_object)
      messages = messages.not_qkunst_private unless current_user.qkunst?
    else
      messages = messages.collections(current_user.collections) if current_user.admin? && current_user.admin_with_favorites?
      messages = messages.thread_can_be_accessed_by_user(current_user).limit_age_to
    end

    @messages = messages.human_messages
    @reminders = messages.system_messages
    new
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @other_messages = if @message.conversation_starter?
      @message.conversation.order_by_creation_date
    else
      @message.replies.order_by_creation_date
    end
    @other_messages = @other_messages.not_qkunst_private unless current_user.admin?

    if @message.subject_object.is_a? Collection
      @collection ||= @message.subject_object
    elsif @message.subject_object.is_a? Work
      @work ||= @message.subject_object
      @collection ||= @work.collection
    end
  end

  # GET /messages/new
  def new
    @message = @new_reply_message
    if params[:message_id]
      @original_message = Message.find(params[:message_id])
      if @original_message
        authorize! :read, @original_message
      end
      # redirect_to messages_path, {alert: "U heeft geen toegang tot deze pagina"} unless current_user.can_access_message?(@original_message)
      @message.in_reply_to_message = @original_message
    end
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)
    @message.from_user = current_user
    @message.subject_object = subject_object
    collection_or_work_url = [@collection, @work].compact.count > 0 ? url_for([@collection, @work].compact) : nil
    referrer = collection_or_work_url || params[:referrer] || request.referrer
    @message.subject_url = referrer unless /\/messages\//.match?(request.referrer)

    authorize! :create, @message

    if message_params[:in_reply_to_message_id].to_i > 0
      original_message = Message.find(message_params[:in_reply_to_message_id].to_i)
      authorize! :read, original_message
    end

    respond_to do |format|
      if @message.save
        notice = "Uw bericht is verstuurd."
        notice += " Het bericht wordt spoedig verwerkt." unless @message.just_a_note || current_user.qkunst?

        redirect_to_obj = @message.subject_url unless /\/messages\//.match?(request.referrer)
        redirect_to_obj ||= @message.conversation_start_message || @message

        format.html { redirect_to redirect_to_obj, notice: notice }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message.conversation_start_message || @message, notice: "Het bericht is aangepast" }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: "Het bericht is verwijderd" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.

  def subject_object
    @subject_object ||= @work || @collection || false
  end

  def set_message
    @message = Message.find(params[:id])
    @subject_object = @message.subject_object

    authorize! :show, @message

    if subject_object
      redirect_to messages_path, {alert: "U heeft geen toegang tot dit bericht"} unless current_user.qkunst? || !@message.qkunst_private
    end
  end

  def set_new_message
    @new_reply_message = Message.new
    @new_reply_message.in_reply_to_message = @message
    if @message
      @new_reply_message.subject = "Re: #{@message.subject}" if /^re:(.*)/i.match?(@message.subject.to_s)
    end
    @new_reply_message.subject = (@work || @collection).try(:name) if @new_reply_message.subject.blank?
    @new_reply_message
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    params.require(:message).permit(:in_reply_to_message_id, :qkunst_private, :subject, :message, :just_a_note, :image, :actioned_upon_by_qkunst_admin)
  end
end
