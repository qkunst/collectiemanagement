class ReportController < ApplicationController
  before_action :set_collection # set_collection includes authentication

  def show
    authorize! :read_report, @collection
    current_user.reset_filters!

    @title = "Rapportage voor #{@collection.name}"

    @inventoried_objects_count = @collection.works_including_child_works.count
    @inventoried_objects_count_in_search = @collection.elastic_aggragations["total"].value
    @works_count = @collection.works_including_child_works.count_as_whole_works


    @sections = {
      Locaties: [[:location_raw]]
    }

    if can?(:read_extended_report, @collection)
      @sections.deep_merge!({
        "Vervaardigers" => [[:artists]],
        "Conditie" => [[:condition_work, :damage_types], [:condition_frame, :frame_damage_types], [:placeability]],
        "Typering" => [[:abstract_or_figurative, :style], [:subset], [:themes], [:tag_list]],
        "Marktwaardering" => [],
        "Vervangingswaardering" => [],
        "Beprijzing" => [],
        "Herkomst" => [[:sources], [:purchase_year]],
        "Object" => [[:object_categories_split], [:object_format_code, :frame_type], [:object_creation_year]],
        "Status" => [[:work_status, :grade_within_collection], [:owner], [:inventoried, :refound, :new_found], [:image_rights, :publish]]
      })
    end

    if can?(:read_valuation, @collection) && @sections["Marktwaardering"]
      @sections["Herkomst"] << [:purchase_price_in_eur]

      @sections["Marktwaardering"] += [[:market_value_range], [:market_value], [:market_value_min_ignore_super]]
      @sections["Vervangingswaardering"] += [[:replacement_value_range], [:replacement_value], [:replacement_value_min_ignore_super]]

      @sections["Beprijzing"] += [[:minimum_bid], [:selling_price]]

    end

    @report = @collection.report

    unless @report
      redirect_to collection_path(@collection), notice: "Het rapport kon niet gegenereerd worden door een systeemfout. De beheerder is geïnformeerd."
    end
  end
end
