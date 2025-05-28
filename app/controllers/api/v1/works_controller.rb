# frozen_string_literal: true

class Api::V1::WorksController < Api::V1::ApiController
  include Works::Filtering

  before_action :authenticate_activated_user!
  before_action :set_collection
  helper_method :exposable_database_fields

  def index
    api_authorize! :read_api, @collection

    @selection = {}

    set_selection_filter
    set_all_filters
    set_work_display_form

    # if work matches a number exactly, don't continue to search
    if @search_text && (@search_text.length > 3)
      @works = @collection.works_including_child_works.has_number(@search_text).to_a
    end

    if @works.blank?
      set_works
      @works = sort_works(preload_relation_ships(@works))
      collection_ids = @works.map(&:collection_id).uniq

      @collection_branches = {}
      collection_ids.each do |id|
        @collection_branches[id] = Collection.find(id).expand_with_parent_collections.not_root.select(:name).map(&:name)
      end
    end

    @works = @works.published if @collection.api_setting_expose_only_published_works?

    if params[:pluck]
      render json: {data: @works.pluck(*(params[:pluck].map(&:to_sym) & exposable_database_fields))}
    end
  rescue Elasticsearch::Transport::Transport::Errors::BadRequest
    render json: {error: "De zoekmachine kon de zoekvraag niet verwerken, pas deze aan", status: 400}, status: 400
  end

  def show
    @collection ||= Work.find(params[:id])&.collection
    api_authorize! :read_api, @collection

    base_work_scope = @collection.works_including_child_works
    base_work_scope = base_work_scope.published if @collection.api_setting_expose_only_published_works?

    @work = base_work_scope.find(params[:id])
  end

  def exposable_database_fields
    @exposable_database_fields ||= current_api_user.ability.viewable_work_fields.select { |a| [String, Symbol].include?(a.class) } - [:style, :medium, :subset, :placeability, :condition_work, :condition_work_id, :condition_frame, :condition_frame_id, :work_status_id, :work_status, :artist_ids, :damage_type_ids, :frame_damage_type_ids, :photo_front, :photo_back, :photo_detail_1, :photo_detail_2, :cluster, :owner, :balance_category] + [:artist_name_for_sorting]
  end

  private

  def set_collection
    @collection ||= @user.accessible_collections.find(params[:collection_id]) if params[:collection_id]
  end
end
