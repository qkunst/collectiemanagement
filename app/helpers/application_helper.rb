# frozen_string_literal: true

module ApplicationHelper
  def offline?
    @offline
  end

  def debug?
    enable_debugging = true
    (params[:debug] == "true" || params[:debug] == true) && enable_debugging
  end

  def kramdown string
    if string&.is_a?(String)
      sanitize Kramdown::Document.new(string, input: :markdown).to_html
    else
      string
    end
  end

  def admin_user?
    current_user&.admin?
  end

  def qkunst_user?
    current_user&.qkunst?
  end

  def facility_management_user?
    current_user&.facility_manager?
  end

  def edit_attachment_path attachment
    if @work
      edit_collection_work_attachment_path(@collection, @work, attachment)
    elsif @artist
      edit_collection_artist_attachment_path(@collection, @artist, attachment)
    else
      edit_collection_attachment_path(attachment.collection, attachment)
    end
  end

  def attachment_path attachment
    if @work
      collection_work_attachment_path(@collection, @work, attachment)
    elsif @artist
      collection_artist_attachment_path(@collection, @artist, attachment)
    else
      collection_attachment_path(attachment.collection, attachment)
    end
  end

  def works_modified_forms_path options = {}
    collection_works_modified_path(@collection)
  end

  def link_to_edit item
    if item.is_a? Array
      item_part = item.collect { |a| a.class.model_name.singular }.join("_")
      url = send("edit_#{item_part}_path".to_sym, *item)
      name = item.last.name
    else
      url = send("edit_#{item.class.model_name.singular}_path".to_sym, item)
      name = item.name
    end
    link_to name, url
  end

  def batch_photo_upload_url batch_photo_upload
    collection_batch_photo_upload_url(batch_photo_upload.collection, batch_photo_upload)
  end

  def visual_boolean boolean
    if boolean.nil?
      "-"
    elsif boolean
      "✔︎"
    else
      "✘"
    end
  end

  def menu_link_to desc, path, options = {}
    test_path = path.include?("//") ? path.sub("//", "").split("/")[1..1000].join("/") : path
    active = (options[:only_exact_path_match] && request.path.to_s == test_path.to_s) || (!options[:only_exact_path_match] && request.path.to_s.starts_with?(test_path.to_s))
    wrap = options[:wrap]

    options = {}
    options[:class] = "active" if active
    options["aria-current"] = "page" if active

    link = link_to desc.to_s, path, options

    if wrap
      sanitize "<li>#{link}</li>"
    else
      link
    end
  end

  def data_to_hidden_inputs data, hierarchy = []
    data.collect do |key, value|
      if value.is_a? Hash
        data_to_hidden_inputs(value, hierarchy + [key])
      else
        # render value
        index = 0
        name = (hierarchy + [key]).map do |a|
          index += 1
          (index == 1) ? a : "[#{a}]"
        end.join

        if value.is_a? Array
          value.map { |a| hidden_field_tag "#{name}[]", a.nil? ? Work::Search::NOT_SET_VALUE : a }
        else
          hidden_field_tag name.to_s, value
        end
      end
    end.join("\n").html_safe
  end
end
