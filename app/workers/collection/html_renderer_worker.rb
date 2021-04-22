# frozen_string_literal: true

class Collection::HtmlRendererWorker
  include Sidekiq::Worker
  include Works::Filtering # Controller concern

  sidekiq_options retry: true, backtrace: true, queue: :qkunst_default

  class FakeWarden
    def initialize(user)
      @user = user
    end
    def authenticated?
      true
    end
    def authenticate(a)
      @user
    end
    def user
      @user
    end
  end

  def perform(collection_id, as_user_id, params = {})
    @params = ActiveSupport::HashWithIndifferentAccess.new(params)
    @collection = Collection.find(collection_id)
    @current_user = User.find(as_user_id)
    @min_index = 0
    @max_index = 99999

    @selection = {}
    set_selection_filter
    set_selection_group
    set_selection_sort
    set_selection_display
    set_selected_localities
    set_no_child_works
    set_search_text

    @collection_works_count = @collection.works_including_child_works.count_as_whole_works

    set_works

    if @selection[:group] != :no_grouping
      set_works_grouped
    else
      reset_works_limited
    end

    renderer = renderer_with_user

    html = renderer.render :_print_index, layout: "print", assigns: {
      collection: @collection,
      for_print: true,
      collection_works_count: @collection_works_count,
      works_count: @works_count,
      inventoried_objects_count: @inventoried_objects_count,
      min_index: 0,
      max_index: @max_index,
      works: @works,
      selection: @selection,
      works_grouped: @works_grouped
    }

    html
  end

  private

  def params
    @params || {}
  end

  def current_user
    @current_user
  end

  def renderer_with_user
    fake_warden = FakeWarden.new(@current_user)
    WorksController.renderer.new("warden"=> fake_warden)
  end
end
