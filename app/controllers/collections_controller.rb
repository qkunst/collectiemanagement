# frozen_string_literal: true

class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy, :manage] # includes authentication
  before_action :set_parent_collection

  # GET /collections
  # GET /collections.json
  def index
    @collections = Collection.for_user(current_user).all
    @title = "Collecties"
    current_user.reset_filters!
    if @collections.count == 1
      redirect_to @collections.first
    end
  end

  def refresh_works
    authorize! :refresh, @parent_collection
    @parent_collection.purge_old_indexed_works!
    @parent_collection.works_including_child_works.all.reindex!
    redirect_to collection_report_path(@parent_collection, params: {time: Time.now.to_i})
  end

  def manage
    authorize! :review, @collection
    @title = @collection.name
    @collections = @collection.child_collections
    current_user.reset_filters!
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
    authorize! :show, @collection
    @title = @collection.name
    @collections = @collection.child_collections
    @attachments = @collection.attachments.for_me(current_user)
    current_user.reset_filters!
  end

  def report
    authorize! :read_report, Collection
    current_user.reset_filters!

    @collection = @parent_collection
    @title = "Rapportage voor #{@collection.name}"

    @sections = {
      "Locaties": [[:"location_raw"]],
      "Ontsluiting" => [[:"tag_list"]]
    }

    if can?(:read_extended_report, @collection)
      @sections.deep_merge!({
        "Vervaardigers" => [[:artists]],
        "Conditie" => [[:condition_work, :damage_types], [:condition_frame, :frame_damage_types], [:placeability]],
        "Typering" => [[:abstract_or_figurative,:style],[:subset],[:themes], [:cluster]],
        "Waardering" => [[:purchase_year],[:grade_within_collection]],
        "Object" => [[:object_categories_split],[:"object_format_code", :frame_type], [:object_creation_year]],
        "Overige" => [[:sources],[:owner],[:inventoried, :refound, :new_found]]
      })
      @sections["Ontsluiting"] = [[:image_rights, :publish],[:"tag_list"]]
    end

    if can?(:read_valuation, @collection) and @sections["Waardering"]
      @sections["Waardering"] << [:market_value]
      @sections["Waardering"] << [:replacement_value]
    end

    @report = @collection.report

    unless @report
      redirect_to collection_path(@collection), notice: "Het rapport kon niet gegenereerd worden door een systeemfout. De beheerder is geïnformeerd."
    end
  end

  # GET /collections/new
  def new
    authorize! :create, @collection
    @collection = Collection.new
  end

  # GET /collections/1/edit
  def edit
    authorize! :update, @collection
  end

  # POST /collections
  # POST /collections.json
  def create
    authorize! :create, @collection
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
    authorize! :update, @collection

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
    authorize! :destroy, @collection

    if @collection.works.count == 0 and @collection.collections.count == 0
      name = @collection.name
      @collection.destroy
      notice = "De collectie “#{name}” is verwijderd."
    elsif @collection.collections.count and @collection.parent_collection
      name = @collection.name
      parent = @collection.parent_collection
      parent_name = parent.name
      @collection.works.each do |w|
        w.collection = parent
        w.save
      end
      if @collection.works.count == 0
        @collection.destroy
        notice = "De collectie “#{name}” is verwijderd, de werken zijn verplaatst naar de bovenliggende collectie “#{parent_name}”"
      end
    else
      @collection.works.destroy_all
      @collection.collections.each do |collection|
        collection.parent_collection = nil
        collection.save
      end
      @collection.destroy
      notice = "De collectie is verwijderd inclusief bijbehorende werken."
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
      @collection = Collection.find(params[:collection_id] || params[:id])
      unless current_user.admin?
        redirect_options = offline? ? {} : {alert: "U heeft geen toegang tot deze collectie"}
        redirect_to root_path, redirect_options unless @collection.can_be_accessed_by_user(current_user)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collection_params
      rv = params.require(:collection).permit(:name, :description, :external_reference_code, :collections_stage_delivery_on, :parent_collection_id, :label_override_work_alt_number_1, :label_override_work_alt_number_2, :label_override_work_alt_number_3, :internal_comments, :sort_works_by, :base, exposable_fields:[], stage_ids: [], geoname_summary_ids: [])
      if rv[:geoname_summary_ids]
        rv[:geoname_summaries] = GeonameSummary.where(geoname_id: rv[:geoname_summary_ids])
        rv.delete(:geoname_summary_ids)
      end
      rv
    end
end
