module ApplicationHelper
  def offline?
    @offline
  end

  def kramdown string
    if string and string.is_a? String
      sanitize Kramdown::Document.new(string, input: :markdown).to_html
    else
      string
    end
  end

  def admin_user?
    current_user && current_user.admin?
  end

  def qkunst_user?
    current_user && current_user.qkunst?
  end

  def facility_management_user?
    current_user && current_user.facility_manager?
  end

  def detail_display?
    @selection and @selection[:display] == :detailed
  end

  def complete_display?
    @selection and @selection[:display] == :complete
  end

  def edit_attachment_path attachment
    if attachment.attache.is_a? Collection
      edit_collection_attachment_path(attachment.attache, attachment)
    elsif attachment.attache.is_a? Work
      edit_collection_work_attachment_path(attachment.attache.collection_id, attachment.attache, attachment)
    end
  end

  def link_to_edit item
    if item.is_a? Array
      item_part = item.collect{|a| a.class.model_name.singular}.join("_")
      url = send("edit_#{item_part}_path".to_sym, *item)
      name = item.last.name
    else
      url = send("edit_#{item.class.model_name.singular}_path".to_sym, item)
      name = item.name
    end
    link_to name, url
  end

  def menu_link_to desc, path, options={}
    test_path = path.include?("//") ? path.sub("//","").split("/")[1..1000].join("/") : path
    if options[:only_exact_path_match]
      class_name = (request.path.to_s == (test_path.to_s)) ? "active" : ""
    else
      class_name = request.path.to_s.starts_with?(test_path.to_s) ? "active" : ""
    end
    link_to "#{desc}", path, class: class_name
  end
end
