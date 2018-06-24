class WorksController < ApplicationController
  include ActionController::Streaming
  include Zipline

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

    @show_work_checkbox = qkunst_user? ? true : false
    @collection_works_count = @collection.works_including_child_works.count

    @selection_display_options = {"Compact"=>:compact, "Basis"=>:detailed}
    @selection_display_options["Compleet"] = :complete unless current_user.read_only?

    @filter_localities = []
    @filter_localities = GeonameSummary.where(geoname_id: @selection_filter["geoname_ids"]) if @selection_filter["geoname_ids"]

    update_current_user_with_params

    @max_index = params["max_index"].to_i if params["max_index"]
    @search_text = params["q"].to_s if params["q"] and !@reset
    @no_child_works = (params[:no_child_works] == 1 or params[:no_child_works] == "true") ? true : false
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
        if can?(:download_datadump, @collection)
          audience = params[:audience] ? params[:audience].to_s.to_sym : :default
          fields_to_expose = @collection.fields_to_expose(audience)
          fields_to_expose = fields_to_expose - ["internal_comments"] unless current_user.qkunst?
          w = @works.to_workbook(fields_to_expose, @collection)
          send_data w.stream_xlsx, :filename => "werken #{@collection.name}.xlsx"
        else
          redirect_to collection_path(@collection), alert: 'U heeft onvoldoende rechten om te kunnen downloaden'
        end
      }
      format.zip {
        if can?(:download_photos, @collection)
          only_front = params[:only_front]
          files = []
          file_editions = only_front ? ["photo_front"] : ["photo_front","photo_back","photo_detail_1", "photo_detail_2"]
          @works.each do |work|
            base_file_name = work.base_file_name
            file_editions.each do |field|
              if work.send("#{field}?".to_sym)
                filename_components = [base_file_name]
                filename_components << field.gsub('photo_','') unless only_front
                filename = "#{filename_components.join("_")}.jpg"
                file = work.send(field.to_sym)
                file_path = params[:hq] ? file.path : file.screen.path
                files << [file_path, filename]
              end
            end
          end
          zipline(files.lazy.map{|path, name| [File.open(path), name]}, "werken #{@collection.name}.zip")
        else
          redirect_to collection_path(@collection), alert: 'U heeft onvoldoende rechten om te kunnen downloaden'
        end
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

  def set_selection_filter
    @selection_filter = current_user.filter_params[:filter] ? current_user.filter_params[:filter] : {}
    if params[:filter] or params[:group] or params[:sort] or params[:display]
      @selection_filter = {}
    end
    if params[:filter] and params[:filter] != ""
      params[:filter].each do |field, values|
        if field == "reset"
          @reset = true
        elsif ["grade_within_collection","abstract_or_figurative","object_format_code.keyword","location","location_raw.keyword", "location_floor_raw.keyword", "location_detail_raw.keyword", "main_collection", "tag_list.keyword"].include?(field)
          @selection_filter[field] =  params[:filter][field].collect{|a| a == "not_set" ? nil : a} if params[:filter][field]
        else
          @selection_filter[field] = clean_ids(values)
        end
      end
    end
    # raise @selection_filter
    return @selection_filter
  end
  def set_selection thing, list
    @selection[thing] = list[0]
    if params[thing] and list.include? params[thing].to_sym
      @selection[thing] = params[thing].to_sym
    elsif current_user.filter_params[thing]
      @selection[thing] = current_user.filter_params[thing].to_sym
    end
    @selection[thing]
  end
  def set_selection_group
    set_selection :group, [:no_grouping, :cluster, :subset, :placeability, :grade_within_collection, :themes, :techniques, :sources]
  end
  def set_selection_sort
    set_selection :sort, [:stock_number, :artist_name]
  end
  def set_selection_display
    set_selection :display, [:compact, :detailed, :complete]
  end

  def set_selection_group_options
    proto_selection_group_options = {
      "Niet"=>:no_grouping,
      "Cluster"=>:cluster,
      "Deelcollectie"=>:subset,
      "Herkomst"=>:sources,
      "Niveau"=>:grade_within_collection,
      "Plaatsbaarheid"=>:placeability,
      "Techniek"=>:techniques,
      "Thema"=>:themes,
    }
    @selection_group_options = {}
    proto_selection_group_options.each do |k,v|
      @selection_group_options[k] = v if current_user.can_filter_and_group?(v)
    end
  end

  def update_current_user_with_params
    current_user.filter_params[:group] = @selection[:group]
    current_user.filter_params[:display] = @selection[:display]
    current_user.filter_params[:sort] = @selection[:sort]
    current_user.filter_params[:filter] = @selection_filter
    current_user.save
  end
  def sort_works works
    if @selection[:sort].to_s == "artist_name"
      works = works.sort{|a,b| a.artist_name_rendered.to_s.downcase <=> b.artist_name_rendered.to_s.downcase}
    else
      works = works.sort{|a,b| a.stock_number.to_s.downcase <=> b.stock_number.to_s.downcase}
    end
    works
  end

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
      :main_collection, :image_rights, :publish, :cluster_name, :collection_id, :cluster_id,
      :placeability_id, artist_ids:[], source_ids: [], damage_type_ids:[], frame_damage_type_ids:[], tag_list: [],
      theme_ids:[],  object_category_ids:[], technique_ids:[], artists_attributes: [
        :_destroy, :first_name, :last_name, :prefix, :place_of_birth, :place_of_death, :year_of_birth, :year_of_death, :description
        ]
      ] if current_user.can_edit_most_of_work?
    params[:work] ? params.require(:work).permit(permitted_fields) : {}
  end
end
