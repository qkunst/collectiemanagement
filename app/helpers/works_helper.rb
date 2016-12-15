module WorksHelper
  # @params set [Hash] with object and counts
  def filter_checkboxes hash, field_name, base_scope = [:activerecord,:values,:work], reference = @selection_filter
    return "Geen verfijning mogelijk" if hash.nil?
    str = ""
    i18n_scope = base_scope << field_name.to_sym
    hash.each do | value, count |
      value_methods = value.methods
      check_box_value = (value_methods.include?(:id) ? value.id : value)
      checked =  reference[field_name] && ( reference[field_name].include?(check_box_value) || reference[field_name].include?(check_box_value.to_s) || (value == :not_set and reference[field_name].include?(nil)))

      str << label_tag do
        label_str = check_box_tag "filter[#{field_name}][]", check_box_value, checked
        if value_methods.include?(:name)
          label_str << value.name
        else
          label_str << I18n.t(value, scope: i18n_scope)
        end
        label_str << " (#{count})"
        label_str
      end
    end
    raw str
  end
end
