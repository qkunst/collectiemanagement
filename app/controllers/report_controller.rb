class ReportController < ApplicationController
  before_action :set_collection # set_collection includes authentication

  def show
    authorize! :read_report, @collection
    current_user.reset_filters!

    @title = "Rapportage voor #{@collection.name}"

    @sections = {
      :Locaties => [[:location_raw]],
      "Ontsluiting" => [[:tag_list]]
    }

    if can?(:read_extended_report, @collection)
      @sections.deep_merge!({
        "Vervaardigers" => [[:artists]],
        "Conditie" => [[:condition_work, :damage_types], [:condition_frame, :frame_damage_types], [:placeability]],
        "Typering" => [[:abstract_or_figurative, :style], [:subset], [:themes], [:cluster]],
        "Waardering" => [[:grade_within_collection, :purchase_year]],
        "Object" => [[:object_categories_split], [:object_format_code, :frame_type], [:object_creation_year]],
        "Overige" => [[:sources], [:owner], [:work_status], [:inventoried, :refound, :new_found]]
      })
      @sections["Ontsluiting"] = [[:image_rights, :publish], [:tag_list]]
    end

    if can?(:read_valuation, @collection) && @sections["Waardering"]
      @sections["Waardering"][0] += [:purchase_price_in_eur]

      if @collection.appraise_with_ranges
        @sections["Waardering"] += [[:market_value_min], [:market_value_max]]
        @sections["Waardering"] += [[:replacement_value_min], [:replacement_value_max]]
      else
        @sections["Waardering"] << [:market_value]
        @sections["Waardering"] << [:replacement_value]
      end

      @sections["Waardering"] << [:minimum_bid, :selling_price]

    end

    @report = @collection.report

    unless @report
      redirect_to collection_path(@collection), notice: "Het rapport kon niet gegenereerd worden door een systeemfout. De beheerder is geïnformeerd."
    end
  end
end
