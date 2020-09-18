# frozen_string_literal: true

module Works::Filtering
  extend ActiveSupport::Concern

  included do
    private

    def set_selection_filter
      @selection_filter = current_user.filter_params[:filter] || {}
      if params[:filter] || params[:group] || params[:sort] || params[:display]
        @selection_filter = {}
      end
      if params[:filter] && (params[:filter] != "") && (params[:filter][:reset] != "true")
        params[:filter].each do |field, values|
          if field == "reset"
            @reset = true
          elsif ["grade_within_collection", "abstract_or_figurative", "object_format_code", "location", "location_raw", "location_floor_raw", "location_detail_raw", "main_collection", "tag_list"].include?(field)
            @selection_filter[field] = params[:filter][field].collect { |a| a == "not_set" ? nil : a } if params[:filter][field]
          elsif Work.column_types[field] == :boolean
            @selection_filter[field] = parse_booleans(values)
          else
            @selection_filter[field] = clean_ids(values)
          end
        end
      end
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

    def set_selection_group
      set_selection :group, [:no_grouping, :cluster, :subset, :placeability, :grade_within_collection, :themes, :techniques, :sources]
    end

    def set_selection_sort
      set_selection :sort, [:stock_number, :artist_name, :location, :created_at]
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
      @selection_display_options["Compleet"] = :complete unless current_user.read_only?
      if current_user.qkunst?
        @selection_display_options["Beperkt"] = :limited
        @selection_display_options["Veilinghuis"] = :limited_auction
        @limit_collection_information = true
      end
      @selection_display_options
    end

    def set_selection_sort_options
      @selection_sort_options = {
        "Inventarisnummer" => :stock_number,
        "Vervaardiger" => :artist_name,
        "Locatie" => :location,
        "Toevoegdatum" => :created_at
      }
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
      noise.collect { |a| [0, "0", false, "false", :false].include?(a) ? false : true }
    end
  end
end
