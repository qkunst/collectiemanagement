module ApplicationHelper
  def offline?
    @offline
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

  def menu_link_to desc, path
    class_name = request.path.to_s.starts_with?(path.to_s) ? "active" : ""
    link_to "#{desc}", path, class: class_name
  end
end
