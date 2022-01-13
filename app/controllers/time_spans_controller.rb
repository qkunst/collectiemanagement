class TimeSpansController < ApplicationController
  authorize_resource
  before_action :set_collection
  before_action :set_work
  before_action :set_time_span, only: %i[ show edit update destroy ]

  # GET /time_spans or /time_spans.json
  def index
    @time_spans = @collection.time_spans.all
  end

  # GET /time_spans/1 or /time_spans/1.json
  def show
  end

  # GET /time_spans/new
  def new
    @time_span = @collection.base_collection.time_spans.new
  end

  # GET /time_spans/1/edit
  def edit
  end

  # POST /time_spans or /time_spans.json
  def create
    @time_span = @collection.base_collection.time_spans.new(time_span_params)

    respond_to do |format|
      if @time_span.save
        format.html { redirect_to [@collection, @work, @time_span].compact, notice: "Time span was successfully created." }
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
        format.html { redirect_to time_span_url(@time_span), notice: "Time span was successfully updated." }
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
      format.html { redirect_to time_spans_url, notice: "Time span was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_span
      @time_span = TimeSpan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def time_span_params
      params.require(:time_span).permit(:starts_at, :ends_at, :status, :contact_id, :subject_id, :subject_type, :status, :classification)
    end

    def set_work
      @work = Work.find_by_id(params[:work_id])
    end
end
