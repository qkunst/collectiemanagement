# frozen_string_literal: true

class ReportController < ApplicationController
  include Works::Filtering

  before_action :set_collection # set_collection includes authentication

  def show
    authorize! :read_report, @collection
    current_user.reset_filters!
    set_all_filters

    if params[:filter_on] == "works"
      redirect_to collection_works_path({filter: selection_filter_to_params, time_filter: @time_filter.to_parameters})
    elsif params[:filter_on] == "create_work_set"
      # raise
      redirect_to new_collection_work_set_path({filter: selection_filter_to_params, time_filter: @time_filter.to_parameters})
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
    Report::Parser.key_model_relations = Collection::KEY_MODEL_RELATIONS.map { |k, v| [k, v.constantize] }.to_h

    filter = @selection_filter
    filter = filter.merge(id: @time_filter.work_ids) if @time_filter.enabled?

    options = {force_elastic: true, return_records: false, no_child_works: @no_child_works, aggregations: Report::Builder.aggregations}

    elastic_works = @collection.search_works("", filter, options)
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

  def selection_filter_to_params
    @selection_filter.map { |a, b| [a, b.map { |c| c.nil? ? :not_set : c }] }.to_h
  end

  def prepare_report_outline
    @sections = {
      Locaties: [[:location_raw]]
    }

    if can?(:read_extended_report, @collection)
      @sections.deep_merge!({
        "Vervaardigers" => [[:artists]],
        "Conditie" => [[:condition_work, :damage_types], [:condition_frame, :frame_damage_types], [:placeability]],
        "Typering" => [[:abstract_or_figurative, :style, :subset], [:cluster], [:themes]],
        "Tags & groepen" => [[:tag_list], [:work_sets]],
        "Marktwaardering" => [],
        "Vervangingswaardering" => [],
        "Beprijzing" => [],
        "Herkomst" => [[:sources], [:purchase_year]],
        "Object" => [[:object_categories_split], [:permanently_fixed, :object_format_code, :frame_type], [:object_creation_year]],
        "Status" => [[:work_status, :grade_within_collection], [:owner], [:inventoried, :refound, :new_found, :checked], [:image_rights, :publish, :has_photo_front]]
      })
    elsif can?(:read_cluster_report, @collection)
      @sections.deep_merge!({
        "Typering" => [[:cluster]]
      })
    end

    if can?(:read_valuation, @collection) && @sections["Marktwaardering"]
      @sections["Herkomst"] << [:purchase_price_in_eur]

      @sections["Marktwaardering"] += [[:market_value_range], [:market_value], [:market_value_min_ignore_super]]
      @sections["Vervangingswaardering"] += [[:replacement_value_range], [:replacement_value], [:replacement_value_min_ignore_super]]

      @sections["Beprijzing"] += [[:minimum_bid], [:selling_price]]
      @sections["Beprijzing"] << [:for_purchase, :for_rent] if @collection&.show_availability_status?
    end

    if @collection&.show_availability_status?
      @sections["Status"] ||= [[]]
      @sections["Status"][0].prepend(:availability_status)
    end
  end
end
