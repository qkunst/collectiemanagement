class WorksController < ApplicationController
  before_action :authenticate_admin_user!, only: [:destroy]
  before_action :authenticate_qkunst_user!, only: [:edit, :update, :create, :new]
  before_action :authenticate_qkunst_or_facility_user!, only: [:edit_location, :update_location]

  before_action :set_collection # set_collection includes authentication
  before_action :set_work, only: [:show, :edit, :update, :destroy, :update_location, :edit_location]

  # GET /works
  # GET /works.json
  def index
    set_selection_filter
    set_selection_group
    set_selection_sort
    set_selection_display

    @show_work_checkbox = true
    @collection_works_count = @collection.works_including_child_works.count

    @selection_display_options = {"Compact"=>:compact, "Basis"=>:detailed}
    @selection_display_options["Compleet"] = :complete unless current_user.read_only?

    update_current_user_with_params

    prepare_clusters_for_selection

    @max_index = params["max_index"].to_i if params["max_index"]

    if params[:offline] == "offline"
      @works = []
    else
      @works = @collection.search_works(nil,@selection_filter,{no_child_works: (params[:no_child_works] ? true : false)})
      @works = @works
    end

    respond_to do |format|
      format.html {
        if @selection_group == "cluster"
          @works_grouped = {}
          works_other = @works - []
          @collection.clusters_including_parent_clusters.order_by_name.each do |cluster|
            @works_grouped[cluster] = sort_works(cluster.works&works_other)
            works_other = works_other - cluster.works
          end
          @works_grouped[nil] = sort_works(works_other)
          @max_index ||= 7
        else
          @works = sort_works(@works)
          @max_index ||= 247
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
    @selection_display = current_user.can_see_details? ? "complete" : "detailed"
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
    if params[:add_or_create_cluster] == "add_or_create_cluster"
      notice = nil
      alert = nil
      selected_works = @collection.works_including_child_works.where(id:params[:selected_works].collect{|a| a.to_i})
      if params[:cluster_existing].to_s == "clusterless"
        selected_works.each do | work |
          work.cluster = nil
          work.save
        end
        notice = "De geselecteerde #{selected_works.count} werken zijn uit de clusters gehaald"
      elsif params[:cluster_existing].starts_with? "collection_"
        collection_id = params[:cluster_existing].gsub("collection_","").to_i
        if collection_id > 0
          collection = Collection.find collection_id
          selected_works.each do | work |
            work.collection = collection
            work.save
          end
          notice = "De geselecteerde #{selected_works.count} werken zijn toegevoegd aan de subcollectie #{collection.name}."
        else
          notice = "Deze collectie bestaat niet"
        end
      elsif params[:cluster_existing].to_i > 0
        cluster = @collection.clusters_including_parent_clusters.find(params[:cluster_existing])
        if cluster != nil
          cluster.works << selected_works
          cluster.touch
          notice = "De geselecteerde #{selected_works.count} werken zijn toegevoegd aan het bestaande cluster #{cluster.name}"
        else
          alert = "De werken zijn niet verplaatst, het geselecteerde cluster bestaat niet in deze of bovenliggende collecties."
        end
      end
      if params[:cluster_new].to_s.strip != ""
        cluster = @collection.clusters.create(name: params[:cluster_new].to_s )
        cluster.works << selected_works
        params[:cluster_existing] = cluster.id
        notice = "De geselecteerde #{selected_works.count} werken zijn toegevoegd aan een nieuwe cluster met de naam #{cluster.name}"

      end
      params[:add_or_create_cluster] = nil
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
        else
          format.html { redirect_to collection_work_path(@collection, @work), notice: 'Het werk is bijgewerkt.' }
        end
        format.json { render :show, status: :ok, location: collection_work_path(@collection,@work) }
      else
        format.html { render :edit }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
    @work.touch
  end

  def update_location
    respond_to do |format|
      work_location_params = params.require(:work).permit(:location_detail, :location)
      if @work.update(work_location_params)
        format.html { redirect_to collection_work_path(@collection, @work), notice: 'Het werk is bijgewerkt.' }
        format.json { render :show, status: :ok, location: collection_work_path(@collection,@work) }
      else
        format.html { render :edit_location }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
    @work.touch
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

  def prepare_clusters_for_selection
    @cluster_options = {}

    @collection.clusters_including_parent_clusters.order_by_name.each do |cluster|
      @cluster_options["cluster “#{cluster.name}”"] = cluster.id
    end
    @cluster_options["overige (geen cluster)"] = :clusterless
    @collection.child_collections.each do |collection|
      @cluster_options["collectie “#{collection.name}”"] = "collection_#{collection.id}"
    end
    if @collection.child_collections.count > 0
      collection = @collection
      # TODO: in future versions make more stable, this might break cluster-functionality!
      @cluster_options["collectie “#{collection.name}”*"] = "collection_#{collection.id}"
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

        elsif ["grade_within_collection","abstract_or_figurative","object_format_code","location","location_raw"].include?(field)
          @selection_filter[field] =  params[:filter][field].collect{|a| a == "not_set" ? nil : a} if params[:filter][field]
        else
          @selection_filter[field] = clean_ids(values)
        end
      end
    end
    return @selection_filter
  end
  def set_selection_group
    @selection_group = "no_grouping"
    if params[:group] and ["cluster", "no_grouping"].include? params[:group].to_s
      @selection_group = params[:group].to_s
    elsif current_user.filter_params[:group]
      @selection_group = current_user.filter_params[:group]
    end
    @selection_group
  end
  def set_selection_sort
    @selection_sort = "stock_number"
    if params[:sort] and ["artist_name", "stock_number"].include? params[:sort].to_s
      @selection_sort = params[:sort].to_s
    elsif current_user.filter_params[:sort]
      @selection_sort = current_user.filter_params[:sort]
    end
    @selection_sort
  end
  def set_selection_display
    @selection_display = "compact"
    if params[:display] and ["compact", "detailed", "complete"].include?(params[:display].to_s)
      @selection_display = params[:display].to_s
    elsif current_user.filter_params[:display]
      @selection_display = current_user.filter_params[:display]
    end
    @selection_display
  end
  def update_current_user_with_params
    current_user.filter_params[:group] = @selection_group
    current_user.filter_params[:display] = @selection_display
    current_user.filter_params[:sort] = @selection_sort
    current_user.filter_params[:filter] = @selection_filter
    current_user.save
  end
  def sort_works works
    if @selection_sort.to_s == "artist_name"
      works = works.sort{|a,b| a.artist_name_rendered <=> b.artist_name_rendered}
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
    redirect_to root_path, alert: "U heeft ook geen toegang tot dit werk via deze collectie!" unless @work.collection == @collection
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def work_params
    if params[:work][:artists_attributes]
      params[:work][:artists_attributes].each do |index, values|
        if values[:id] or values[:_destroy].to_i == "1"
          params[:work][:artists_attributes].delete(index)
        end
      end
    end
    params.require(:work).permit(:location_detail, :locality_geoname_id, :imported_at, :import_collection_id, :valuation_on, :internal_comments, :created_by, :location, :stock_number, :alt_number_1, :alt_number_2, :alt_number_3, :photo_front, :photo_back, :photo_detail_1, :photo_detail_2, :artist_unknown, :title, :title_unknown, :description, :object_creation_year, :object_creation_year_unknown, :medium_id, :signature_comments, :no_signature_present, :print, :frame_height, :frame_width, :frame_depth, :frame_diameter, :height, :width, :depth, :diameter, :condition_work_id, :condition_work_comments, :condition_frame_id, :condition_frame_comments, :information_back, :other_comments, :source_comments, :style_id, :subset_id, :market_value, :replacement_value, :purchase_price, :price_reference, :grade_within_collection, :entry_status, :entry_status_description, :abstract_or_figurative, :medium_comments, :purchase_price_currency_id, :placeability_id, artist_ids:[], source_ids: [], damage_type_ids:[], frame_damage_type_ids:[], theme_ids:[],  object_category_ids:[], technique_ids:[], artists_attributes: [:_destroy, :first_name, :last_name, :prefix, :place_of_birth, :place_of_death, :year_of_birth, :year_of_death, :description])
  end
end
