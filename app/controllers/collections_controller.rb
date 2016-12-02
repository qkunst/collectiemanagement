class CollectionsController < ApplicationController
  before_action :authenticate_admin_user!, only: [:destroy, :create, :new]
  before_action :authenticate_qkunst_user!, only: [:edit, :update, :report]
  before_action :set_collection, only: [:show, :edit, :update, :destroy] #includes authentication
  before_action :set_parent_collection

  # GET /collections
  # GET /collections.json
  def index
    @collections = admin_user? ? Collection.without_parent.all : Collection.for_user(current_user).all
    current_user.reset_filters!
    if @collections.count == 1
      redirect_to @collections.first
    end
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
    current_user.reset_filters!
  end

  def report
    @collection = @parent_collection
    current_user.reset_filters!
  end

  # GET /collections/new
  def new

    @collection = Collection.new
  end

  # GET /collections/1/edit
  def edit
  end

  # POST /collections
  # POST /collections.json
  def create
    @collection = Collection.new(collection_params)
    if @parent_collection
      @collection.parent_collection = @parent_collection
    end
    respond_to do |format|
      if @collection.save
        format.html { redirect_to @collection, notice: 'De collectie is aangemaakt.' }
        format.json { render :show, status: :created, location: @collection }
      else
        format.html { render :new }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update
    respond_to do |format|
      @collection.label_override_work_alt_number_1 = collection_params[:label_override_work_alt_number_1]
      @collection.label_override_work_alt_number_2 = collection_params[:label_override_work_alt_number_2]
      @collection.label_override_work_alt_number_3 = collection_params[:label_override_work_alt_number_3]
      touch_all_works = @collection.changes.keys.count > 0
      if @collection.update(collection_params)
        @collection.works_including_child_works.all.collect{|a| a.touch} if touch_all_works
        format.html { redirect_to @collection, notice: 'De collectie is bijgewerkt.' }
        format.json { render :show, status: :ok, location: @collection }
      else
        format.html { render :edit }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy
    if @collection.works.count == 0 and @collection.collections.count == 0
      @collection.destroy
      notice = "De collectie “#{params[:collection][:name]}” is verwijderd."
    else
      notice = "De collectie kon niet verwijderd worden omdat deze nog werken heeft en/of subcollecties"
    end

    respond_to do |format|
      format.html { redirect_to collections_url, notice: notice }
      format.json { head :no_content }
    end
  end

  private
    def set_parent_collection
      if params[:collection_id]
        @parent_collection = Collection.find(params[:collection_id])
      end
    end

    def set_collection
      authenticate_activated_user!
      @collection = Collection.find(params[:id])
      unless current_user.admin?
        redirect_options = offline? ? {} : {alert: "U heeft geen toegang tot deze collectie"}
        redirect_to root_path, redirect_options unless @collection.can_be_accessed_by_user(current_user)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collection_params
      params.require(:collection).permit(:name, :description, :parent_collection_id, :label_override_work_alt_number_1, :label_override_work_alt_number_2, :label_override_work_alt_number_3, exposable_fields:[])
    end
end
