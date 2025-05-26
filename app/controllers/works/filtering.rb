# frozen_string_literal: true

module Works::Filtering
  extend ActiveSupport::Concern

  MAX_WORK_COUNT = 99999
  DEFAULT_WORK_COUNT = 159
  DEFAULT_GROUPED_WORK_COUNT = 7
  IDS_TO_SELECT_WHEN_GROUPING = {
    cluster: [:id, :cluster_id],
    subset: [:id, :subset_id],
    placeability: [:id, :placeability_id],
    grade_within_collection: [:id, :grade_within_collection]
  }

  included do
    private

    def reset_filter?
      @reset ||= parse_boolean(params.dig(:filter, :reset))
    end

    # sets filter starting with empty or a user's previous filter; but reset when params are present that modify the state
    def initiate_filter
      @selection_filter = current_user&.filter_params&.[](:filter) || {}
      if params[:filter] || params[:work_display_form] || params[:ids] || params[:work_ids_comma_separated] || params[:time_filter]
        @selection_filter = {}
      end
    end

    def set_all_filters
      set_selection_filter
      set_time_filter
      set_no_child_works
      set_search_text
    end

    def set_time_filter
      time_filter_params = {}
      if params[:time_filter]
        time_filter_params[:start] = params[:time_filter][:start]
        time_filter_params[:end] = params[:time_filter][:end]
        time_filter_params[:enabled] = params[:time_filter][:enabled]
        time_filter_params[:name] = params[:time_filter][:name]
      end
      time_filter_params = time_filter_params.select { |_, v| v.present? }
      time_filter_params[:base_scope] = @collection.works_including_child_works
      @time_filter = TimeFilter.new(time_filter_params)
    end

    def set_work_display_form
      work_display_form_params = {current_user: current_user, collection: @collection}

      # api compatibility
      work_display_form_params[:sort] = params[:sort]
      work_display_form_params[:group] = params[:group]
      work_display_form_params[:display] = params[:display]

      if params[:work_display_form]
        forced_action_controller_params = params.is_a?(ActionController::Parameters) ? params : ActionController::Parameters.new(params)

        work_display_form_params = work_display_form_params.merge(forced_action_controller_params.require(:work_display_form).permit(:group, :sort, :display, :hide_empty_fields, attributes_to_display: []))
      end
      @work_display_form = WorkDisplayForm.new(work_display_form_params)
      @work_display_form.sort = :id if params[:id_gt]
      @work_display_form
    end

    def set_selection_filter
      initiate_filter

      if reset_filter?
        current_user.reset_filters!
        @selection_filter = {}
      elsif params[:filter]
        params[:filter].each do |field, values|
          if field == "work_sets.uuid"
            @selection_filter["work_sets.id"] ||= []
            @selection_filter["work_sets.id"] += WorkSet.where(uuid: values).pluck(:id)
          elsif ["grade_within_collection", "abstract_or_figurative", "object_format_code", "main_collection", "tag_list", "availability_status"].include?(field)
            @selection_filter[field] = params[:filter][field].collect { |a| (a == Work::Search::NOT_SET_VALUE) ? nil : a } if params[:filter][field]
          elsif ["location_raw", "location_floor_raw", "location_detail_raw"].include?(field)
            @selection_filter[field] = params[:filter][field] if params[:filter][field]
          elsif Work.column_types[field.to_s] == :boolean || CollectionReportHelper::BOOLEANS.include?(field.to_sym)
            @selection_filter[field] = parse_booleans(values)
          else
            @selection_filter[field] = clean_ids(values)
          end
        end
      end

      @selection_filter
    end

    def preload_relation_ships(works)
      works.preload_relations_for_display(@work_display_form.display)
    end

    def set_works
      filter = @selection_filter
      filter = filter.merge(id: @time_filter.work_ids) if @time_filter&.enabled?
      options = {force_elastic: false, return_records: true, no_child_works: @no_child_works}

      @works = @collection.search_works(@search_text, filter || {}, options)
      @works = @works.published if params[:published]
      @works = @works.where(id: Array(params[:ids]).join(",").split(",").map(&:to_i)) if params[:ids]
      @works = @works.significantly_updated_since(DateTime.parse(params[:significantly_updated_since])) if params[:significantly_updated_since]

      @inventoried_objects_count = @works.distinct.count
      @works_count = @works.count_as_whole_works
      @works = @works.limit(params[:limit].to_i) if params[:limit]
      @works = @works.offset(params[:from].to_i) if params[:from]
      @works = @works.where(id: ((params[:id_gt].to_i + 1)...)) if params[:id_gt]
    end

    def sort_works(works)
      works.except(:order).order_by(@work_display_form.sort)
    end

    def set_works_grouped
      works_grouped = {}

      selection_group = @work_display_form.group

      include_selection_group = [selection_group] - [:grade_within_collection]

      @works.select(IDS_TO_SELECT_WHEN_GROUPING[selection_group || :id]).includes(include_selection_group).each do |work|
        groups = work.send(selection_group)
        groups = nil if groups.methods.include?(:count) && groups.methods.include?(:all) && (groups.count == 0)
        [groups].flatten.each do |group|
          works_grouped[group] ||= []
          works_grouped[group] << work.id
        end
      end

      @max_index = params["max_index"] ? params["max_index"].to_i : DEFAULT_GROUPED_WORK_COUNT
      @max_index ||= (@works_count < DEFAULT_WORK_COUNT) ? MAX_WORK_COUNT : DEFAULT_GROUPED_WORK_COUNT
      @works_grouped = {}
      works_grouped.keys.compact.sort.each do |key|
        @works_grouped[key] = works_grouped[key].uniq
      end
      if works_grouped[nil]
        @works_grouped[nil] = works_grouped[nil].uniq
      end

      @works_grouped = @works_grouped.map { |k, v| [k, sort_works(preload_relation_ships(Work.where(id: v)))] }.to_h
    end

    def reset_works_limited
      @min_index = params["min_index"] ? params["min_index"].to_i : 0
      @max_index = params["max_index"] ? params["max_index"].to_i : DEFAULT_WORK_COUNT

      work_ids = if @works.is_a? Array
        @works[@min_index..@max_index].uniq.map(&:id)
      else
        @works.offset(@min_index).limit(@max_index - @min_index + 1).pluck(:id).uniq
      end
      @works = sort_works(preload_relation_ships(Work.where(id: work_ids)))
    end

    def set_selected_localities
      @filter_localities = @selection_filter["geoname_ids"] ? GeonameSummary.where(geoname_id: @selection_filter["geoname_ids"]) : []
    end

    def set_no_child_works
      @no_child_works = parse_boolean(params[:no_child_works])
    end

    def set_search_text
      @search_text = params["q"].to_s if params["q"] && !reset_filter?
    end

    def update_current_user_with_params
      current_user.filter_params[:group] = @work_display_form.group
      current_user.filter_params[:display] = @work_display_form.display
      current_user.filter_params[:sort] = @work_display_form.sort
      current_user.filter_params[:filter] = @selection_filter
      current_user.save
    end

    private

    def clean_ids noise
      if noise
        noise.collect { |a| (a == Work::Search::NOT_SET_VALUE) ? nil : a.to_i }
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
