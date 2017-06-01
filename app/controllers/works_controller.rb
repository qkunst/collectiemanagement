class WorksController < ApplicationController
  before_action :authenticate_admin_user!, only: [:destroy]
  before_action :authenticate_qkunst_user!, only: [:edit, :create, :new, :edit_photos]
  before_action :authenticate_qkunst_or_facility_user!, only: [:edit_location, :update]
  before_action :set_work, only: [:show, :edit, :update, :destroy, :update_location, :edit_location, :edit_photos]
  before_action :set_collection # set_collection includes authentication

  # NOTE: every now and then an error is raised, and the app will try to repost the same request, which results in an error. It is accepted that an external party could create additional, unwanted records (though highly unlikely due to the obscureness of this app (and they would still need login credentials))
  skip_before_action :verify_authenticity_token, only: [:create]

  # GET /works
  # GET /works.json

  def index
    @selection = {}
    set_selection_filter
    set_selection_group
    set_selection_sort
    set_selection_display

    @show_work_checkbox = qkunst_user? ? true : false
    @collection_works_count = @collection.works_including_child_works.count

    @selection_display_options = {"Compact"=>:compact, "Basis"=>:detailed}
    @selection_display_options["Compleet"] = :complete unless current_user.read_only?

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
    @filter_localities = []
    @filter_localities = GeonameSummary.where(geoname_id: @selection_filter["locality_geoname_id"]) if @selection_filter["locality_geoname_id"]

    update_current_user_with_params

    prepare_batch_editor_selection

    @max_index = params["max_index"].to_i if params["max_index"]
    @search_text = params["q"].to_s if params["q"] and !@reset
    @no_child_works = (params[:no_child_works] == 1 or params[:no_child_works] == "true") ? true : false
    begin
      @works = @collection.search_works(@search_text, @selection_filter, {force_elastic: false, return_records: true, no_child_works: @no_child_works})
      @works_count = @works.count
    rescue Elasticsearch::Transport::Transport::Errors::BadRequest
      @works = []
      @works_count = 0
      @alert = "De zoekopdracht werd niet begrepen, pas de zoekopdracht aan."
    rescue Faraday::ConnectionFailed
      @works = []
      @works_count = 0
      @alert = "Momenteel kan er niet gezocht worden, de zoekmachine (ElasticSearch) draait niet (meer) of is onjuist ingesteld."
    end

    @aggregations = @collection.works_including_child_works.fast_aggregations([:themes,:subset,:grade_within_collection,:placeability,:cluster,:sources,:techniques, :object_categories, :geoname_ids])


    @title = "Werken van #{@collection.name}"
    respond_to do |format|
      format.html {
        if @selection[:group] != :no_grouping
          works_grouped = {}
          @works.each do |work|
            group = work.send(@selection[:group])
            group = nil if group.methods.include?(:count) and group.methods.include?(:all) and group.count == 0
            [group].flatten.each do | group |
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
        if current_user.can_download?
          w = nil
          audience = params[:audience] ? params[:audience].to_s.to_sym : :default
          fields_to_expose = @collection.fields_to_expose(audience)
          fields_to_expose = fields_to_expose - ["internal_comments"] unless current_user.qkunst?
          w = @works.to_workbook(fields_to_expose, @collection)
          send_data  w.stream_xlsx, :filename => "werken #{@collection.name}.xlsx"
        else
          redirect_to collection_path(@collection), alert: 'U heeft onvoldoende rechten om te kunnen downloaden'
        end
      }
      format.zip {
        if current_user.can_download?
          zipfile_name = File.join(Rails.root,["tmp",[Digest::SHA256.new.update("#{@collection.name}#{@collection.id}sec1ure#{Time.now.hour.to_s}#{Time.now.to_date.to_s}").digest].pack("m0").strip.gsub(/[\/\.\=\+]/,"")])
          unless File.exists?(zipfile_name)
            io = Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
              @works.each do |work|
                base_file_name = work.base_file_name
                ["photo_front","photo_back","photo_detail_1", "photo_detail_2"].each do |field|
                  if work.send("#{field}?".to_sym)
                    filename = "#{base_file_name}_#{field.gsub('photo_','')}.jpg"
                    begin
                      zipfile.add(filename, work.send(field.to_sym).screen.path)
                    rescue Zip::ZipEntryExistsError
                      zipfile.add(filename+" (#{work.id})", work.send(field.to_sym).screen.path)
                    end
                  end
                end
              end
            end
          end
          puts "sending #{zipfile_name}..."
          send_file zipfile_name, :filename => "fotos #{@collection.name}.zip"
        else
          redirect_to collection_path(@collection), alert: 'U heeft onvoldoende rechten om te kunnen downloaden'
        end
      }
    end
  end

  # GET /works/1
  # GET /works/1.json
  def show
    @selection = {}
    @selection[:display] = current_user.can_see_details? ? :complete : :detailed
    @title = @work.name

  end

  def edit_photos

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
  # POST /works.json
  def create
    if params[:batch_edit] == "batch_edit" and params[:batch_edit_property]
      notice = nil
      alert = nil
      selected_works = @collection.works_including_child_works.where(id:params[:selected_works].collect{|a| a.to_i})

      property_being_edited = ["collection_id", "grade_within_collection", "cluster_id", "location_detail", "location_floor", "location", "subset_id", "theme.id", "technique.id", "source.id"].select{|a| params[:batch_edit_property].starts_with?(a) }.first

      if property_being_edited
        if property_being_edited.ends_with?("_id")
          id = params[:batch_edit_property].gsub("#{property_being_edited}_","")
          value = nil
          unless id == "nil"
            klass = property_being_edited.gsub("_id","").classify.constantize
            if id.to_i.to_s == id
              value = klass.find(id)
            elsif id == "new"
              if current_user.qkunst?
                value = klass.new(name: params[:batch_edit_new_name])
                value.collection = @collection if value.methods.include?(:collection)
                value.save
              end
            else
              raise id
            end

          end
          selected_works.each{|a| a.send("#{property_being_edited}=", value ? value.id : nil); a.save}
          notice = "Wijziging (#{I18n.t property_being_edited.gsub("_id",""), scope: [:activerecord, :attributes, :work]} = #{ value ? value.name : "geen"}) doorgevoerd voor #{selected_works.count} werken."
        elsif property_being_edited.ends_with?(".id")
            id = params[:batch_edit_property].gsub("#{property_being_edited}_","")
            value = nil
            unless id == "nil"
              klass = property_being_edited.gsub(".id","").classify.constantize
              if id.to_i.to_s == id
                value = klass.find(id)
              else
                raise id
              end
            end
            property_name = "#{property_being_edited.gsub(".id","")}s"
            selected_works.each{|a| a.send(property_name).push(value); a.reindex! }
            notice = "Wijziging (#{I18n.t property_name, scope: [:activerecord, :attributes, :work]} = #{ value ? value.name : "geen"}) doorgevoerd voor #{selected_works.count} werken."

        else
          value = params[:batch_edit_property].gsub("#{property_being_edited}_","")
          value = nil if value == "nil"
          value = params[:batch_edit_new_name] if value == "new"
          selected_works.each{|a| a.send("#{property_being_edited}=", value); a.save}
          notice = "Wijziging (#{I18n.t property_being_edited, scope: [:activerecord, :attributes, :work]} = #{value}) doorgevoerd voor #{selected_works.count} werken."
        end
      end

      params[:batch_edit] = nil
      params[:selected_works] = []
      params[:cluster_new] = nil
      params[:action] = nil
      params[:id] = nil
      params[:format] = :html
      params[:authenticity_token] = nil
      respond_to do |format|
        format.html {
          redirect_to collection_works_path(@collection), notice: notice, alert: alert

        }
      end
    else
      # raise "fail"
      @work = Work.new(work_params)
      @work.collection = @collection
      @work.created_by = current_user
      respond_to do |format|
        if @work.save
          format.html { redirect_to collection_work_path(@collection,@work), notice: 'Het werk is aangemaakt' }
          format.json { render :show, status: :created, location: collection_work_path(@collection,@work) }
        else
          format.html { render :new }
          format.json { render json: @work.errors, status: :unprocessable_entity }
        end
      end
    end

  end

  # PATCH/PUT /works/1
  # PATCH/PUT /works/1.json
  def update
    respond_to do |format|
      if @work.update(work_params)
        if ["1", 1, true].include? params["submit_and_edit_next"]
          format.html { redirect_to edit_collection_work_path(@collection, @work.next), notice: 'Het werk is bijgewerkt, nu de volgende.' }
        elsif ["1", 1, true].include? params["submit_and_edit_photos_in_next"]
          format.html { redirect_to collection_work_path(@collection, @work.next, params: {show_in_context: collection_work_edit_photos_path(@collection,@work.next)}), notice: 'Het werk is bijgewerkt, nu de volgende.' }
        else
          format.html { redirect_to collection_work_path(@collection, @work), notice: 'Het werk is bijgewerkt.' }
        end
        format.json { render :show, status: :ok, location: collection_work_path(@collection,@work) }
      else
        format.html { render :edit }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit_location

  end

  # DELETE /works/1
  # DELETE /works/1.json
  def destroy
    @work.destroy
    respond_to do |format|
      format.html { redirect_to collection_works_url(@collection), notice: 'Het werk is definitief verwijderd uit de QKunst database' }
      format.json { head :no_content }
    end
  end

  private

  def prepare_batch_editor_selection
    @batch_edit_options = {"Cluster" => {}, "Deelcollectie" => {}, "Collectie" => {}, "Herkomst" => {}, "Niveau" => {}, "Locatie" => {}, "Technieken"=>{}, "Thema's"=>{}}

    @collection.clusters_including_parent_clusters.each do |cluster|
      @batch_edit_options["Cluster"]["Zet in cluster “#{cluster.name}”"] = "cluster_id_#{cluster.id}"
    end
    @batch_edit_options["Cluster"]["Haal uit cluster (geen cluster)"] = :cluster_id_nil
    @batch_edit_options["Cluster"]["Zet in nieuw cluster"] = :cluster_id_new

    %w{A B C D E F G}.each do |grade|
      @batch_edit_options["Niveau"]["Niveau #{grade}"] = "grade_within_collection_#{grade}"
    end

    @collection.child_collections.each do |collection|
      @batch_edit_options["Collectie"]["Verplaats naar collectie “#{collection.name}”"] = "collection_id_#{collection.id}"
    end

    if @collection.child_collections.count > 0
      collection = @collection
      @batch_edit_options["Collectie"]["Verplaats naar collectie “#{collection.name}”*"] = "collection_id_#{collection.id}"
    end

    Subset.all.each do |subset|
      @batch_edit_options["Deelcollectie"]["Zet in deelcollectie “#{subset.name}”"] = "subset_id_#{subset.id}"
    end

    @batch_edit_options["Locatie"]["Nieuwe adres en/of gebouw(deel)"] = "location_new"
    @batch_edit_options["Locatie"]["Nieuwe verdieping"] = "location_floor_new"
    @batch_edit_options["Locatie"]["Nieuwe locatie specificatie"] = "location_detail_new"

    Technique.all.each do |technique|
      @batch_edit_options["Technieken"]["Voeg ook techniek “#{technique.name}” toe"] = "technique.id_#{technique.id}"
    end

    Source.all.each do |source|
      @batch_edit_options["Herkomst"]["Voeg herkomst “#{source.name}” toe"] = "source.id_#{source.id}"
    end

    @collection.available_themes.each do |theme|
      @batch_edit_options["Thema's"]["Voeg thema “#{theme.name}” toe"] = "theme.id_#{theme.id}"

    end

  end

  def set_selection_filter
    @selection_filter = current_user.filter_params[:filter] ? current_user.filter_params[:filter] : {}
    # raise @selection_filter
    if params[:filter] or params[:group] or params[:sort] or params[:display]
      @selection_filter = {}
    end
    if params[:filter] and params[:filter] != ""
      params[:filter].each do |field, values|
        if field == "reset"
          @reset = true
        elsif ["grade_within_collection","abstract_or_figurative","object_format_code","location","location_raw"].include?(field)
          @selection_filter[field] =  params[:filter][field].collect{|a| a == "not_set" ? nil : a} if params[:filter][field]
        else
          @selection_filter[field] = clean_ids(values)
        end
      end
    end
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
    @work = Work.find( params[:id] || params[:work_id] )
    redirect_to collection_work_path(@work.collection, @work) unless request.path.to_s.starts_with?(collection_work_path(@work.collection, @work))
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def work_params
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
      :main_collection, :image_rights, :publish,
      :placeability_id, artist_ids:[], source_ids: [], damage_type_ids:[], frame_damage_type_ids:[],
      theme_ids:[],  object_category_ids:[], technique_ids:[], artists_attributes: [
        :_destroy, :first_name, :last_name, :prefix, :place_of_birth, :place_of_death, :year_of_birth, :year_of_death, :description
        ]
      ] if current_user.can_edit_most_of_work?
    params[:work] ? params.require(:work).permit(permitted_fields) : {}
  end
end
