class TimeSpansController < ApplicationController
  authorize_resource
  before_action :set_collection
  before_action :set_subject
  before_action :set_time_span, only: %w[show edit update destroy]
  before_action :set_contacts, only: [:new, :edit, :create, :update]

  # GET /time_spans or /time_spans.json
  def index
    @time_spans = (@subject || @collection).time_spans.includes(:subject, :contact).all
  end

  # GET /time_spans/1 or /time_spans/1.json
  def show
  end

  # GET /time_spans/new
  def new
    @time_span = @collection.base_collection.time_spans.new(starts_at: Time.now, subject: @subject, status: :concept)
  end

  # GET /time_spans/1/edit
  def edit
  end

  # POST /time_spans or /time_spans.json
  def create
    @time_span = @collection.base_collection.time_spans.new({collection_id: @collection.base_collection.id}.merge(time_span_params))
    @time_span.subject = @subject
    respond_to do |format|
      if @time_span.save
        format.html { redirect_to [@collection, @subject].compact, notice: "De gebeurtenis is gestart." }
        format.json { render :show, status: :created, location: @time_span }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @time_span.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_spans/1 or /time_spans/1.json
  def update
    respond_to do |format|
      if @time_span.update(time_span_params)
        format.html { redirect_to [@collection, @subject], notice: "De gebeurtenis is aangepast." }
        format.json { render :show, status: :ok, location: @time_span }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @time_span.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_spans/1 or /time_spans/1.json
  def destroy
    @time_span.end_time_span!

    respond_to do |format|
      format.html { redirect_to [@collection, @subject], notice: "De gebeurtenis is beëindigd." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.

  # Only allow a list of trusted parameters through.
  def time_span_params
    params.require(:time_span).permit(:starts_at, :ends_at, :status, :contact_id, :status, :comments, :classification, :contact, :collection_id)
  end

  def set_work
    @work = current_user.accessible_works.find_by_id(params[:work_id]) if params[:work_id]
  end

  def set_work_set
    @work_set = WorkSet.find(params[:work_set_id]) if params[:work_set_id]
  end

  def set_time_span
    @time_span = if @subject
      @subject.time_spans.find_by_id(params[:id] || params[:time_span_id]) || @subject.time_spans.find_by_uuid(params[:id] || params[:time_span_id])
    else
      TimeSpan.find(params[:id] || params[:time_span_id])
    end
  end

  def set_subject
    @subject = set_work || set_work_set
    authorize!(:manage, TimeSpan) if @subject.nil?
  end

  def set_contacts
    @contacts = @collection.base_collection.contacts.internal
    @contacts += @collection.base_collection.contacts.external.without_url
    @contacts += Uitleen::Customer.all(current_user: current_user) if Uitleen.configured? && current_user.central_login_provided_auth?
    @contacts = @contacts.sort_by(&:name)
  end
end
