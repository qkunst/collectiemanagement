class WorksController < ApplicationController
  include ActionController::Streaming
  include Works::ZipResponse
  include Works::XlsxResponse
  include Works::Filtering

  before_action :authenticate_admin_user!, only: [:destroy]
  before_action :authenticate_qkunst_user!, only: [:edit, :create, :new, :edit_photos]
  before_action :authenticate_qkunst_or_facility_user!, only: [:edit_location, :update, :edit_tags]
  before_action :set_work, only: [:show, :edit, :update, :destroy, :update_location, :edit_location, :edit_photos, :edit_tags]
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
      @works_count = @works.count
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

    @works = @works.published if params[:published]
    @works.includes(:collection)

    @cleaned_params = params.to_unsafe_h.merge({cluster_new: nil, utf8: nil, action:nil, batch_edit_property: nil, collection_id: nil, controller: nil, authenticity_token: nil, button: nil})

    @title = "Werken van #{@collection.name}"
    respond_to do |format|
      format.html {
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
          works_grouped.each do |key, works|
            works_grouped[key] = sort_works(works)
          end
          @max_index ||= @works_count < 159 ? 99999 : 7
          @works_grouped = {}
          works_grouped.keys.compact.sort.each do |key|
            @works_grouped[key] = works_grouped[key]
          end
          if works_grouped[nil]
            @works_grouped[nil] = works_grouped[nil]
          end
        else
          @works = sort_works(@works)
          @max_index ||= 159
          @max_index = 159 if @max_index < 159
        end
      }
      format.xlsx {
        show_xlsx_response
      }
      format.zip {
        show_zip_response
      }
    end
  end

  # GET /works/1
  def show
    @selection = {}
    @selection[:display] = current_user.can_see_details? ? :complete : :detailed
    @custom_reports = @work.custom_reports.to_a
    @title = @work.name
  end

  def edit_photos
  end

  def edit_tags
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
    else
      render :edit
    end
  end

  def edit_location
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
    begin
      @work = current_user.accessible_works.find( params[:id] || params[:work_id] )
      redirect_to collection_work_path(@work.collection, @work) unless request.path.to_s.starts_with?(collection_work_path(@work.collection, @work))
    rescue
      redirect_to root_path, warning: "Geen toegang"
    end
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
    permitted_fields = []
    permitted_fields += [:location_detail, :location, :location_floor] if current_user.can_edit_location?
    permitted_fields += [:internal_comments] if current_user.qkunst?
    permitted_fields += [
      :photo_front, :photo_back, :photo_detail_1, :photo_detail_2,
      :remove_photo_front, :remove_photo_back, :remove_photo_detail_1, :remove_photo_detail_2
    ] if current_user.can_edit_photos?
    permitted_fields += [
      :locality_geoname_id, :imported_at, :import_collection_id, :stock_number, :alt_number_1, :alt_number_2, :alt_number_3,
      :artist_unknown, :title, :title_unknown, :description, :object_creation_year, :object_creation_year_unknown, :medium_id, :frame_type_id,
      :signature_comments, :no_signature_present, :print, :frame_height, :frame_width, :frame_depth, :frame_diameter,
      :height, :width, :depth, :diameter, :condition_work_id, :condition_work_comments, :condition_frame_id, :condition_frame_comments,
      :information_back, :other_comments, :source_comments, :style_id, :subset_id,  :public_description,
      :grade_within_collection, :entry_status, :entry_status_description, :abstract_or_figurative, :medium_comments,
      :main_collection, :image_rights, :publish, :cluster_name, :collection_id, :cluster_id, :owner_id,
      :placeability_id, artist_ids:[], source_ids: [], damage_type_ids:[], frame_damage_type_ids:[], tag_list: [],
      theme_ids:[],  object_category_ids:[], technique_ids:[], artists_attributes: [
        :_destroy, :first_name, :last_name, :prefix, :place_of_birth, :place_of_death, :year_of_birth, :year_of_death, :description
        ]
      ] if current_user.can_edit_most_of_work?
    params[:work] ? params.require(:work).permit(permitted_fields) : {}
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

end
