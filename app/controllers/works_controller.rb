class WorksModifiedForm
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment

  attr_accessor :only_location_changes
  attr_accessor :only_non_qkunst

  def only_location_changes?
    truthy?(only_location_changes)
  end

  def only_non_qkunst?
    truthy?(only_non_qkunst)
  end

  private

  def truthy?(var)
    var == "1" || var == true || var == "true"
  end
end
# frozen_string_literal: true

class WorksController < ApplicationController
  include ActionController::Streaming
  include Works::ZipResponse
  include Works::XlsxResponse
  include Works::Filtering

  before_action :authenticate_admin_or_advisor_user!, only: [:destroy, :modified_index]
  before_action :authenticate_qkunst_user!, only: [:edit, :create, :new, :edit_photos]
  before_action :authenticate_qkunst_or_facility_user!, only: [:edit_location, :update, :edit_tags]
  before_action :set_work, only: [:show, :edit, :update, :destroy, :update_location, :edit_location, :edit_photos, :edit_tags, :location_history, :edit_prices]
  before_action :set_collection # set_collection includes authentication

  # NOTE: every now and then an error is raised, and the app will try to repost the same request, which results in an error. It is accepted that an external party could create additional, unwanted records (though highly unlikely due to the obscureness of this app (and they would still need login credentials))
  skip_before_action :verify_authenticity_token, only: [:create]

  # GET /works
  # GET /works.zip
  # GET /works.xlsx

  def index
    @selection = {}
    set_selection_filter
    set_selection_group
    set_selection_sort
    set_selection_display
    set_selection_group_options
    set_selection_sort_options
    set_selection_display_options

    @show_work_checkbox = qkunst_user? ? true : false
    @collection_works_count = @collection.works_including_child_works.count


    @filter_localities = []
    @filter_localities = GeonameSummary.where(geoname_id: @selection_filter["geoname_ids"]) if @selection_filter["geoname_ids"]

    update_current_user_with_params

    @max_index = params["max_index"].to_i if params["max_index"]
    @search_text = params["q"].to_s if params["q"] and !@reset
    @no_child_works = (params[:no_child_works] == 1 or params[:no_child_works] == "true") ? true : false

    if redirect_directly_to_work_using_search_text
      return true
    end

    begin
      @works = @collection.search_works(@search_text, @selection_filter, {force_elastic: false, return_records: true, no_child_works: @no_child_works})
      @works = @works.published if params[:published]
      @works = @works.id(params[:ids].split(",").map(&:to_i)) if params[:ids]
      @works_count = @works.count
      @works = @works.preload_relations_for_display(@selection[:display])
      @works = @works.except(:order).order_by(@selection[:sort]) if @selection[:sort]
    rescue Elasticsearch::Transport::Transport::Errors::BadRequest => e
      @works = []
      @works_count = 0
      @alert = "De zoekopdracht werd niet begrepen, pas de zoekopdracht aan."
    rescue Faraday::ConnectionFailed => e
      @works = []
      @works_count = 0
      @alert = "Momenteel kan er niet gezocht worden, de zoekmachine (ElasticSearch) draait niet (meer) of is onjuist ingesteld."
    end

    @aggregations = @collection.works_including_child_works.fast_aggregations([:themes,:subset,:grade_within_collection,:placeability,:cluster,:sources,:techniques, :object_categories, :geoname_ids, :main_collection])

    @cleaned_params = params.to_unsafe_h.merge({cluster_new: nil, utf8: nil, action:nil, batch_edit_property: nil, collection_id: nil, controller: nil, authenticity_token: nil, button: nil})

    @title = "Werken van #{@collection.name}"
    respond_to do |format|
      format.xlsx { show_xlsx_response }
      format.csv { show_csv_response }
      format.zip { show_zip_response }

      format.html do
        if @selection[:group] != :no_grouping
          works_grouped = {}
          @works.each do |work|
            groups = work.send(@selection[:group])
            groups = nil if groups.methods.include?(:count) and groups.methods.include?(:all) and groups.count == 0
            [groups].flatten.each do | group |
              works_grouped[group] ||= []
              works_grouped[group] << work
            end
          end
          @max_index ||= @works_count < 159 ? 99999 : 7
          @works_grouped = {}
          works_grouped.keys.compact.sort.each do |key|
            @works_grouped[key] = works_grouped[key].uniq
          end
          if works_grouped[nil]
            @works_grouped[nil] = works_grouped[nil].uniq
          end
        else
          @max_index ||= 159
          @max_index = 159 if @max_index < 159
          @works = @works.limit(@max_index).all
        end
      end
    end
  end

  # GET /works/1
  def show
    @selection = {}
    @selection[:display] = can?(:show_details, @work) ? :complete : :detailed
    @custom_reports = @work.custom_reports.to_a
    @title = @work.name
  end

  def edit_photos
  end

  def edit_tags
  end

  def edit_prices
  end

  # GET /works/new
  def new
    @work = Work.new
    @work.purchase_price_currency = Currency.find_by_iso_4217_code("EUR")
  end

  # GET /works/1/edit
  def edit
  end

  # POST /works
  def create
    @work = Work.new(work_params)
    @work.collection = @collection
    @work.created_by = current_user
    if @work.save
      redirect_to collection_work_path(@collection,@work), notice: 'Het werk is aangemaakt'
    else
      render :new
    end
  end

  # PATCH/PUT /works/1
  def update
    if @work.update(work_params)
      if ["1", 1, true].include? params["submit_and_edit_next"]
        redirect_to edit_collection_work_path(@collection, @work.next), notice: 'Het werk is bijgewerkt, nu de volgende.'
      elsif ["1", 1, true].include? params["submit_and_edit_photos_in_next"]
        redirect_to collection_work_path(@collection, @work.next, params: {show_in_context: collection_work_edit_photos_path(@collection,@work.next)}), notice: 'Het werk is bijgewerkt, nu de volgende.'
      elsif ["1", 1, true].include? params["submit_and_edit_tags_in_next"]
        redirect_to collection_work_path(@collection, @work.next, params: {show_in_context: collection_work_edit_tags_path(@collection,@work.next)}), notice: 'Het werk is bijgewerkt, nu de volgende.'
      else
        redirect_to collection_work_path(@collection, @work), notice: 'Het werk is bijgewerkt.'
      end
    elsif can?(:edit, @work)
      render :edit
    else
      redirect_to collection_work_path(@collection, @work), notice: 'Het werk kon niet worden aangepast, neem contact op met QKunst om de wijziging te maken.'
    end
  end

  def edit_location
  end

  def location_history
    location_versions = []
    @work.versions.each_with_index do |version, index|
      location_versions[index] = {created_at: version.created_at, event: version.event, user: User.where(id: version.whodunnit).first&.name}
      if version.object and index > 0
        reified_object = version.reify
        location_versions[index-1][:location] = reified_object.location
        location_versions[index-1][:location_floor] = reified_object.location_floor
        location_versions[index-1][:location_detail] = reified_object.location_detail
      end
    end

    # complete with latest info
    index = location_versions.count

    location_versions[index-1][:location] = @work.location
    location_versions[index-1][:location_floor] = @work.location_floor
    location_versions[index-1][:location_detail] = @work.location_detail

    # filter out irrelevant changes
    uniq_location_versions = [location_versions[0]]
    location_versions.each do |location_version|
      last_uniq_location_version = uniq_location_versions.last
      if (location_version[:location] != last_uniq_location_version[:location] ||
        location_version[:location_floor] != last_uniq_location_version[:location_floor] ||
        location_version[:location_detail] != last_uniq_location_version[:location_detail])
        uniq_location_versions << location_version
      end
    end

    @versions = uniq_location_versions
  end

  def modified_index
    versions = PaperTrail::Version.where(item_id: @collection.works_including_child_works.select(:id), item_type: "Work").order(created_at: :desc).limit(500)

    @form = WorksModifiedForm.new(works_modified_form_params)
    # raise @form
    versions = versions.where.not(whodunnit: User.qkunst.select(:id).map(&:id)) if @form.only_non_qkunst?
    versions = versions.where("versions.object_changes LIKE '%location%'") if @form.only_location_changes?

    @works_with_version_created_at = versions.includes(:item).order(created_at: :desc).collect{|a| [a.created_at, a.reify, User.where(id: a.whodunnit).first&.name]}.compact
  end

  # DELETE /works/1
  def destroy
    @work.destroy
    redirect_to collection_works_url(@collection), notice: 'Het werk is definitief verwijderd uit de QKunst database'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def clean_ids noise
    noise ? noise.collect{|a| a == "not_set" ? nil : a.to_i} : []
  end

  def set_work
    @work = current_user.accessible_works.find( params[:work_id] || params[:id])
    redirect_to collection_work_path(@work.collection, @work) unless request.path.to_s.starts_with?(collection_work_path(@work.collection, @work))
  end

  def work_params
    reusable_work_params( params, current_user )
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def reusable_work_params params, current_user
    if params[:work] and params[:work][:artists_attributes]
      params[:work][:artists_attributes].each do |index, values|
        if values[:id] or values[:_destroy].to_i == "1"
          params[:work][:artists_attributes].delete(index)
        end
      end
    end

    params[:work] ? params.require(:work).permit(current_user.ability.editable_work_fields) : {}
  end


  def redirect_directly_to_work_using_search_text
    if @search_text and @search_text.length > 3
      works = @collection.works_including_child_works.has_number(@search_text).to_a

      if works.count == 1
        work = works[0]
        redirect_to collection_work_path(work.collection, work)
        return true
      end
    end
    return false
  end

  def works_modified_form_params
    if params["works_modified_form"]
      params.require(:works_modified_form).permit(:only_location_changes, :only_non_qkunst)
    else
      {}
    end
  end
end
