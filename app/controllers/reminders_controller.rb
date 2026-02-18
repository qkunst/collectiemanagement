# frozen_string_literal: true

class RemindersController < ApplicationController
  before_action :set_collection

  before_action :set_reminder, only: [:show, :edit, :update, :destroy]

  # GET /reminders
  # GET /reminders.json
  def index
    authorize! :index, Reminder

    @reminders = if @collection
      collection_scope
    else
      collection_scope.prototypes
    end
  end

  # GET /reminders/1
  # GET /reminders/1.json
  def show
    authorize! :show, @reminder
  end

  # GET /reminders/new
  def new
    @reminder = Reminder.new
    authorize! :new, @reminder
  end

  # GET /reminders/1/edit
  def edit
    authorize! :edit, @reminder
  end

  # POST /reminders
  # POST /reminders.json
  def create
    @reminder = collection_scope.new(reminder_params)
    authorize! :create, @reminder

    @reminder.collection = @collection
    redirect_path = @collection ? collection_reminders_path(@collection) : reminders_path
    respond_to do |format|
      if @reminder.save
        format.html { redirect_to redirect_path, notice: "Herinnering is aangemaakt" }
        format.json { render :show, status: :created, location: @reminder }
      else
        format.html { render :new }
        format.json { render json: @reminder.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /reminders/1
  # PATCH/PUT /reminders/1.json
  def update
    authorize! :update, @reminder

    redirect_path = @collection ? collection_reminders_path(@collection) : reminders_path
    respond_to do |format|
      if @reminder.update(reminder_params)
        format.html { redirect_to redirect_path, notice: "Herinnering is bijgewerkt" }
        format.json { render :show, status: :ok, location: @reminder }
      else
        format.html { render :edit }
        format.json { render json: @reminder.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /reminders/1
  # DELETE /reminders/1.json
  def destroy
    authorize! :destroy, @reminder

    @collection = @reminder.collection
    @reminder.destroy
    respond_to do |format|
      format.html { redirect_to (@collection ? collection_reminders_url(@collection) : reminders_url), notice: "Herinnering is verwijderd" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_reminder
    @reminder = collection_scope.find(params[:id])
  end

  def collection_scope
    authenticate_admin_user! unless @collection

    if current_user.admin? && @collection.nil?
      Reminder.where("1=1")
    else
      @collection.reminders
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def reminder_params
    params.require(:reminder).permit(:name, :text, :stage_id, :interval_length, :interval_unit, :repeat)
  end
end
