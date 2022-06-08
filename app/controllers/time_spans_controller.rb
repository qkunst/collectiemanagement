class TimeSpansController < ApplicationController
  authorize_resource
  before_action :set_collection
  before_action :set_subject
  before_action :set_time_span, only: %w[ show edit update destroy ]
  before_action :set_contacts, only: [:new, :edit]

  # GET /time_spans or /time_spans.json
  def index
    @time_spans = (@subject || @collection).time_spans.includes(:subject, :contact).all
  end

  # GET /time_spans/1 or /time_spans/1.json
  def show

  end

  # GET /time_spans/new
  def new
    redirect_back fallback_location: [@collection, @subject], allow_other_host: false, notice: "Niet (alles is) beschikbaar" unless @subject.available?
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
    @time_span.destroy

    respond_to do |format|
      format.html { redirect_to time_spans_url, notice: "De gebeurtenis is verwijderd." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    # Only allow a list of trusted parameters through.
    def time_span_params
      params.require(:time_span).permit(:starts_at, :ends_at, :status, :contact_id, :status, :classification, :contact)
    end

    def set_work
      @work = current_user.accessible_works.find_by_id(params[:work_id]) if params[:work_id]
    end

    def set_work_set
      @work_set = WorkSet.find(params[:work_set_id]) if params[:work_set_id]
    end

    def set_time_span
      @time_span = @subject ? @subject.time_spans.find(params[:id] || params[:time_span_id]) : TimeSpan.find(params[:id] || params[:time_span_id])
    end

    def set_subject
      @subject = set_work || set_work_set
      authorize!(:manage, TimeSpan) if @subject.nil?
    end

    def set_contacts
      @contacts = @collection.base_collection.contacts.internal
      @contacts += Uitleen::Customer.all(current_user: current_user) if Uitleen.configured?
    end
end
