class MessagesController < ApplicationController
  before_action :authenticate_admin_or_facility_user!
  before_action :set_work
  before_action :set_collection
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.conversation_starters.order_by_reverse_creation_date
    if subject_object
      @messages = @messages.for(subject_object)
      @messages = @messages.not_qkunst_private
    else
      @messages = @messages.thread_can_be_accessed_by_user(current_user) unless current_user.admin?
    end
    new
  end



  # GET /messages/1
  # GET /messages/1.json
  def show
    if @message.conversation_starter?
      @other_messages = @message.conversation.order_by_creation_date
    else
      @other_messages = @message.replies.order_by_creation_date
    end
    @other_messages = @other_messages.not_qkunst_private unless current_user.admin?

    if @message.subject_object.is_a? Collection
      @collection ||= @message.subject_object
    elsif @message.subject_object.is_a? Work
      @work ||= @message.subject_object
      @collection ||= @work.collection
    end
    if current_user.admin?
      @message.update_attributes(actioned_upon_by_qkunst_admin_at: Time.now)
      @message.conversation.update_all(actioned_upon_by_qkunst_admin_at: Time.now)
    end
    @new_reply_message = Message.new
    @new_reply_message.in_reply_to_message = @message
    @new_reply_message.subject = @message.subject.to_s.match(/^re\:(.*)/i) ? @message.subject : "Re: #{@message.subject}"
  end

  # GET /messages/new
  def new
    @message = Message.new
    if params[:message_id]
      @original_message = Message.find(params[:message_id])
      redirect_to messages_path, {alert: "U heeft geen toegang tot deze pagina"} unless (current_user.can_access_message?(@original_message))
      @message.in_reply_to_message = @original_message
      @message.subject = @original_message.subject.match(/^re(.*)/i) ? @original_message.subject : "Re: #{@original_message.subject}"
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
    @message.subject_url = referrer unless request.referrer.match(/\/messages\//)

    if message_params[:in_reply_to_message_id].to_i > 0
      original_message = Message.find(message_params[:in_reply_to_message_id].to_i)
      unless (current_user.can_access_message?(original_message))
        redirect_to messages_path, {alert: "U probeert te reageren op een bericht welke u niet heeft kunnen zien."}
        return false
      end
      original_message.actioned_upon_by_qkunst_admin! if current_user.admin?
    end

    respond_to do |format|
      if @message.save
        notice = "Uw bericht is opgeslagen."
        notice += " Het bericht wordt spoedig verwerkt." unless @message.just_a_note or current_user.qkunst?

        redirect_to_obj = @message.subject_url unless request.referrer.match(/\/messages\//)
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
      unless current_user.can_edit_message?(@message)
        redirect_to @message.conversation_start_message || @message, {alert: "U probeert iets aan te passen dat u niet mag aanpassen."}
        return nil
      end
      mparams=message_params
      if @message.update(mparams)
        format.html { redirect_to @message.conversation_start_message || @message, notice: 'Het bericht is aangepast' }
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
      format.html { redirect_to messages_url, notice: 'Het bericht is verwijderd' }
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
      if subject_object
        redirect_to messages_path, {alert: "U heeft geen toegang tot dit bericht"} unless (current_user.qkunst? or !@message.qkunst_private)
      else
        redirect_to messages_path, {alert: "U heeft geen toegang tot dit bericht"} unless (current_user.can_access_message?(@message))
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:to_user_id, :in_reply_to_message_id, :qkunst_private, :subject, :message, :just_a_note, :image)
    end
end
