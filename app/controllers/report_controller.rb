class ReportController < ApplicationController
  include Works::Filtering

  before_action :set_collection # set_collection includes authentication

  def show
    authorize! :read_report, @collection
    current_user.reset_filters!
    set_selection_filter
    set_no_child_works

    if params[:filter_on] == "works"
      redirect_to collection_works_path(filter: params[:filter].to_unsafe_h)
    end

    @title = "Rapportage voor #{@collection.name}"
    @show_filter_check_boxes = can?(:filter_report, @collection)

    prepare_report
    prepare_report_outline

    unless @report
      redirect_to collection_path(@collection), notice: "Het rapport kon niet gegenereerd worden door een systeemfout. De beheerder is geïnformeerd."
    end
  end

  private

  def prepare_report
    Report::Parser.key_model_relations = Collection::KEY_MODEL_RELATIONS.map{ |k, v| [k, v.constantize] }.to_h

    elastic_works = @collection.search_works("", @selection_filter, {force_elastic: true, return_records: false, no_child_works: @no_child_works, aggregations: Report::Builder.aggregations})
    elastic_aggregations = elastic_works.aggregations

    @report = Report::Parser.parse(elastic_aggregations)

    if @selection_filter
      base_report = Report::Parser.parse(@collection.search_works("", {}, {force_elastic: true, return_records: false, no_child_works: @no_child_works, aggregations: Report::Builder.aggregations}).aggregations, base_report: true)
      @report = base_report.deep_merge(@report)
    end

    @inventoried_objects_count_in_search = elastic_aggregations["total"].value
    @inventoried_objects_count = elastic_works.count

    @works_count = elastic_works.records.count_as_whole_works
    @collection_works_count = @collection.works_including_child_works.count_as_whole_works
  end

  def prepare_report_outline
    @sections = {
      Locaties: [[:location_raw]]
    }

    if can?(:read_extended_report, @collection)
      @sections.deep_merge!({
        "Vervaardigers" => [[:artists]],
        "Conditie" => [[:condition_work, :damage_types], [:condition_frame, :frame_damage_types], [:placeability]],
        "Typering" => [[:abstract_or_figurative, :style, :subset], [:cluster], [:themes], [:tag_list]],
        "Marktwaardering" => [],
        "Vervangingswaardering" => [],
        "Beprijzing" => [],
        "Herkomst" => [[:sources], [:purchase_year]],
        "Object" => [[:object_categories_split], [:permanently_fixed, :object_format_code, :frame_type], [:object_creation_year]],
        "Status" => [[:work_status, :grade_within_collection], [:owner], [:inventoried, :refound, :new_found], [:image_rights, :publish]]
      })
    end

    if can?(:read_valuation, @collection) && @sections["Marktwaardering"]
      @sections["Herkomst"] << [:purchase_price_in_eur]

      @sections["Marktwaardering"] += [[:market_value_range], [:market_value], [:market_value_min_ignore_super]]
      @sections["Vervangingswaardering"] += [[:replacement_value_range], [:replacement_value], [:replacement_value_min_ignore_super]]

      @sections["Beprijzing"] += [[:minimum_bid], [:selling_price]]
    end
  end
end
