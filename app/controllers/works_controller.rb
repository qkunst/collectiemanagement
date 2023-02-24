# frozen_string_literal: true

class WorksController < ApplicationController
  include ActionController::Streaming
  include Works::ZipResponse
  include Works::XlsxResponse
  include Works::XmlResponse
  include Works::PdfResponse
  include Works::Filtering

  before_action :authenticate_qkunst_user!, only: [:edit, :create, :new, :edit_photos]
  before_action :authenticate_qkunst_or_facility_user!, only: [:edit_location, :update, :edit_tags]
  before_action :set_work, only: [:show, :edit, :update, :destroy, :update_location, :edit_location, :edit_photos, :edit_tags, :location_history, :edit_prices, :show_old_data]
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
    set_no_child_works
    set_selected_localities

    @show_work_checkbox = qkunst_user?
    @collection_works_count = @collection.works_including_child_works.count_as_whole_works

    update_current_user_with_params

    @min_index = params["min_index"].to_i if params["min_index"]
    @min_index ||= 0
    @max_index = params["max_index"].to_i if params["max_index"]

    if redirect_directly_to_work_using_search_text
      return true
    end

    begin
      set_works
    rescue Elasticsearch::Transport::Transport::Errors::BadRequest => e
      @works = []
      @works_count = 0
      @inventoried_objects_count = 0
      @alert = "De zoekopdracht werd niet begrepen, pas de zoekopdracht aan."
      logger.error("Elasticsearch::Transport::Transport::Errors::BadRequest: #{e.message}")
    rescue Faraday::ConnectionFailed
      @works = []
      @works_count = 0
      @inventoried_objects_count = 0
      @alert = "Momenteel kan er niet gezocht worden, de zoekmachine (ElasticSearch) draait niet (meer) of is onjuist ingesteld."
    end

    @aggregations = @collection.works_including_child_works.fast_aggregations([:themes, :subset, :grade_within_collection, :placeability, :cluster, :sources, :techniques, :object_categories, :geoname_ids, :main_collection])

    @cleaned_params = params.to_unsafe_h.merge({cluster_new: nil, utf8: nil, action: nil, batch_edit_property: nil, collection_id: nil, controller: nil, authenticity_token: nil, button: nil})

    @title = "Werken van #{@collection.name}"

    respond_to do |format|
      format.xlsx { show_xlsx_response }
      format.pdf { show_pdf_response }
      format.xml { show_xml_response }
      format.csv { show_csv_response }
      format.zip { show_zip_response }

      format.html do
        if @selection[:group] != :no_grouping
          set_works_grouped
        else
          reset_works_limited
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
    @work = @collection.works.new
    @work.created_by = current_user
    @work.purchase_price_currency = Currency.find_by_iso_4217_code("EUR")
  end

  # GET /works/1/edit
  def edit
  end

  # POST /works
  def create
    @work = @collection.works.new(work_params.merge({collection_id: @collection.id}))
    @work.created_by = current_user
    if @work.save
      redirect_to collection_work_path(@collection, @work), notice: "Het werk is aangemaakt"
    else
      render :new
    end
  end

  # PATCH/PUT /works/1
  def update
    if @work.update(work_params)
      if ["1", 1, true].include? params["submit_and_edit_next"]
        redirect_to edit_collection_work_path(@collection, @work.next), notice: "Het werk is bijgewerkt, nu de volgende."
      elsif ["1", 1, true].include? params["submit_and_edit_photos_in_next"]
        redirect_to collection_work_path(@collection, @work.next, params: {show_in_context: collection_work_edit_photos_path(@collection, @work.next)}), notice: "Het werk is bijgewerkt, nu de volgende."
      elsif ["1", 1, true].include? params["submit_and_edit_tags_in_next"]
        redirect_to collection_work_path(@collection, @work.next, params: {show_in_context: collection_work_edit_tags_path(@collection, @work.next)}), notice: "Het werk is bijgewerkt, nu de volgende."
      else
        redirect_to collection_work_path(@collection, @work), notice: "Het werk is bijgewerkt."
      end
    elsif can?(:edit, @work)
      render :edit
    else
      redirect_to collection_work_path(@collection, @work), notice: "Het werk kon niet worden aangepast, neem contact op met #{I18n.t("application.responsible_party")} om de wijziging te maken."
    end
  end

  def edit_location
  end

  def location_history
    @versions = @work.location_history
  end

  def modified_index
    authorize! :review_modified_works, @collection
    versions = PaperTrail::Version.where(item_id: @collection.works_including_child_works.select(:id), item_type: "Work").where.not(object_changes: nil).order(created_at: :desc).limit(250).includes(:item).order(created_at: :desc)

    @form = Works::ModifiedForm.new(works_modified_form_params)

    versions = versions.where.not(whodunnit: User.qkunst.select(:id).map(&:id)) if @form.only_non_qkunst?
    versions = versions.where("versions.object_changes LIKE '%location%'") if @form.only_location_changes?

    versions = versions.where("versions.created_at >= ?", @form.from_date.beginning_of_day) if @form.from_date
    versions = versions.where("versions.created_at <= ?", @form.to_date.end_of_day) if @form.to_date

    if @form.active?
      versions = versions.limit(2500)
    end

    @result_count = versions.count
    @unlimited_result_count = versions.unscope(:limit).count
    @works_with_version_created_at = versions.collect { |a| [a.created_at, a.reify, User.where(id: a.whodunnit).first&.name, (a.object_changes ? YAML.load(a.object_changes) : {})] }.compact # standard:disable Security/YAMLLoad # object_changes is created by papertrail
  end

  # DELETE /works/1
  def destroy
    authorize! :destroy, @work
    @work.destroy
    redirect_to collection_works_url(@collection), notice: "Het werk is definitief verwijderd uit de #{I18n.t("application.name")} database"
  end

  def show_old_data
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_work
    @work = current_user.accessible_works.find((params[:work_id] || params[:id]).to_i)
    redirect_to collection_work_path(@work.collection, @work) unless request.path.to_s.starts_with?(collection_work_path(@work.collection, @work))
  end

  def work_params
    # sanitized parameters, using the users ability
    reusable_work_params(params, current_user)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def reusable_work_params params, current_user
    if params[:work] && params[:work][:artists_attributes]
      params[:work][:artists_attributes].each do |index, values|
        if values[:id] || (values[:_destroy].to_i == "1")
          params[:work][:artists_attributes].delete(index)
        end
      end
    end

    params[:work] ? params.require(:work).permit(current_user.ability.editable_work_fields) : {}
  end

  def redirect_directly_to_work_using_search_text
    if @search_text && (@search_text.length > 3)
      works = @collection.works_including_child_works.has_number(@search_text).to_a

      if works.count == 1
        work = works[0]
        redirect_to collection_work_path(work.collection, work)
        return true
      end
    end
    false
  end

  def works_modified_form_params
    if params["works_modified_form"]
      params.require(:works_modified_form).permit(:only_location_changes, :only_non_qkunst, :from_date, :to_date)
    else
      {}
    end
  end
end
