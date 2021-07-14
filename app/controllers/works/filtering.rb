# frozen_string_literal: true

module Works::Filtering
  extend ActiveSupport::Concern

  MAX_WORK_COUNT = 99999
  DEFAULT_WORK_COUNT = 159
  DEFAULT_GROUPED_WORK_COUNT = 7

  included do
    private

    def reset_filter?
      @reset ||= parse_boolean(params.dig(:filter, :reset))
    end

    def set_selection_filter
      @selection_filter = current_user.filter_params[:filter] || {}
      if params[:filter] || params[:group] || params[:sort] || params[:display]
        @selection_filter = {}
      end

      if params[:filter] && !reset_filter?
        params[:filter].each do |field, values|
          if field == "reset"
          elsif ["grade_within_collection", "abstract_or_figurative", "object_format_code", "location", "location_raw", "location_floor_raw", "location_detail_raw", "main_collection", "tag_list"].include?(field)
            @selection_filter[field] = params[:filter][field].collect { |a| a == "not_set" ? nil : a } if params[:filter][field]
          elsif Work.column_types[field.to_s] == :boolean
            @selection_filter[field] = parse_booleans(values)
          else
            @selection_filter[field] = clean_ids(values)
          end
        end
      end

      set_search_text

      @selection_filter
    end

    def set_selection thing, list
      @selection[thing] = list[0]
      if params[thing] && list.include?(params[thing].to_sym)
        @selection[thing] = params[thing].to_sym
      elsif current_user.filter_params[thing]
        @selection[thing] = current_user.filter_params[thing].to_sym
      end
      @selection[thing]
    end

    def set_works
      @works = @collection.search_works(@search_text, @selection_filter, {force_elastic: false, return_records: true, no_child_works: @no_child_works})
      @works = @works.published if params[:published]
      @works = @works.where(id: Array(params[:ids]).join(",").split(",").map(&:to_i)) if params[:ids]
      @inventoried_objects_count = @works.count
      @works_count = @works.count_as_whole_works
      @works = @works.preload_relations_for_display(@selection[:display])
      @works = @works.except(:order).order_by(@selection[:sort]) if @selection[:sort]
    end

    def set_works_grouped
      works_grouped = {}
      @works.each do |work|
        groups = work.send(@selection[:group])
        groups = nil if groups.methods.include?(:count) && groups.methods.include?(:all) && (groups.count == 0)
        [groups].flatten.each do |group|
          works_grouped[group] ||= []
          works_grouped[group] << work
        end
      end
      @max_index ||= @works_count < DEFAULT_WORK_COUNT ? MAX_WORK_COUNT : DEFAULT_GROUPED_WORK_COUNT
      @works_grouped = {}
      works_grouped.keys.compact.sort.each do |key|
        @works_grouped[key] = works_grouped[key].uniq
      end
      if works_grouped[nil]
        @works_grouped[nil] = works_grouped[nil].uniq
      end
    end

    def reset_works_limited
      @max_index ||= DEFAULT_WORK_COUNT
      @works = if @works.is_a? Array
        @works[0..@max_index].uniq
      else
        @works.offset(@min_index).limit(@max_index - @min_index + 1).uniq
      end
    end

    def set_selected_localities
      @filter_localities = @selection_filter["geoname_ids"] ? GeonameSummary.where(geoname_id: @selection_filter["geoname_ids"]) : []
    end

    def set_selection_group
      set_selection :group, [:no_grouping, :cluster, :subset, :placeability, :grade_within_collection, :themes, :techniques, :sources]
    end

    def set_selection_sort
      set_selection :sort, [:stock_number, :artist_name, :location, :created_at, :created_at_asc, :significantly_updated_at, :significantly_updated_at_asc]
    end

    def set_selection_display
      set_selection :display, set_selection_display_options.collect { |k, v| v }
    end

    def set_selection_group_options
      proto_selection_group_options = {
        "Niet" => :no_grouping,
        "Cluster" => :cluster,
        "Deelcollectie" => :subset,
        "Herkomst" => :sources,
        "Niveau" => :grade_within_collection,
        "Plaatsbaarheid" => :placeability,
        "Techniek" => :techniques,
        "Thema" => :themes
      }
      @selection_group_options = {}
      proto_selection_group_options.each do |k, v|
        @selection_group_options[k] = v if current_user.can_filter_and_group?(v)
      end
    end

    def set_selection_display_options
      @selection_display_options = {"Compact" => :compact, "Basis" => :detailed}
      if /vermist/i.match?(@collection.name)
        @selection_display_options["Basis met locatiegeschiedenis"] = :detailed_with_location_history
      end
      @selection_display_options["Basis Discreet"] = :detailed_discreet if current_user.qkunst? || current_user.facility_manager?
      @selection_display_options["Compleet"] = :complete unless current_user.read_only?
      if current_user.qkunst?
        @selection_display_options["Beperkt"] = :limited
        @selection_display_options["Veilinghuis"] = :limited_auction
      end
      @selection_display_options
    end

    def set_selection_sort_options
      @selection_sort_options = {
        "Inventarisnummer" => :stock_number,
        "Vervaardiger" => :artist_name,
        "Locatie" => :location,
        "Toevoegdatum (nieuwste eerst)" => :created_at,
        "Toevoegdatum (oudste eerst)" => :created_at_asc,
        "Wijzigingsdatum (nieuwste eerst)" => :significantly_updated_at,
        "Wijzigingsdatum (oudste eerst)" => :significantly_updated_at_asc
      }
    end

    def set_no_child_works
      @no_child_works = parse_boolean(params[:no_child_works])
    end

    def set_search_text
      @search_text = params["q"].to_s if params["q"] && !reset_filter?
    end

    def update_current_user_with_params
      current_user.filter_params[:group] = @selection[:group]
      current_user.filter_params[:display] = @selection[:display]
      current_user.filter_params[:sort] = @selection[:sort]
      current_user.filter_params[:filter] = @selection_filter
      current_user.save
    end

    private

    def clean_ids noise
      if noise
        noise.collect { |a| a == "not_set" ? nil : a.to_i }
      else
        []
      end
    end

    def parse_booleans noise
      noise.map do |bit|
        parse_boolean bit
      end
    end

    def parse_boolean fake_boolean
      {"0" => false, "false" => false, "1" => true, "true" => true}[fake_boolean.to_s]
    end
  end
end
