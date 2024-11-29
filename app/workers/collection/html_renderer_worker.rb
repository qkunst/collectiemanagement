# frozen_string_literal: true

class Collection::HtmlRendererWorker
  include Sidekiq::Worker
  include Works::Filtering # Controller concern

  sidekiq_options retry: true, backtrace: true, queue: :qkunst_quick

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

    attr_reader :user
  end

  # params => as request params, Works::Filtering Concern (a controller concern) is used in this worker
  # options: { send_message: Bool, generate_pdf: Bool}

  def perform(collection_id, as_user_id, params = {}, options = {})
    @params = ActiveSupport::HashWithIndifferentAccess.new(params.is_a?(String) ? JSON.parse(params) : params)
    options = ActiveSupport::HashWithIndifferentAccess.new(options)
    @collection = Collection.find(collection_id)
    @current_user = User.find(as_user_id)
    @min_index = 0
    @max_index = 99999

    @selection = {}
    set_selection_filter

    set_work_display_form
    set_selected_localities
    set_no_child_works
    set_search_text
    set_time_filter

    @collection_works_count = @collection.works_including_child_works.count_as_whole_works

    set_works

    if @work_display_form.group != :no_grouping
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
      max_index: 999999,
      works: @works,
      selection: @selection,
      works_grouped: @works_grouped,
      work_display_form: @work_display_form
    }

    filename = Rails.root.join("tmp/#{SecureRandom.base58(32)}.html")

    File.write(filename, html)

    if options[:generate_pdf] && options[:send_message]
      PdfPrinterWorker.perform_async(filename.to_s, {inform_user_id: (options[:send_message] ? as_user_id : nil), subject_object_id: @collection.id, subject_object_type: "Collection"}.stringify_keys)
    elsif !options[:generate_pdf] && options[:send_message]
      Message.create(to_user_id: inform_user_id, subject_object: subject_object, from_user_name: "Download voorbereider", attachment: File.open(filename), message: "De download is gereed, open het bericht in je browser om de bijlage te downloaden.\n\nFormaat: HTML", subject: "HTML download gereed")
    end

    html
  end

  private

  def params
    @params || {}
  end

  attr_reader :current_user

  def renderer_with_user
    fake_warden = FakeWarden.new(@current_user)
    WorksController.renderer.new("warden" => fake_warden)
  end
end
