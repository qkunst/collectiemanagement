module WorksHelper
  # @params set [Hash] with object and counts
  def filter_checkboxes_with_header header, hash, field_name, options={}
    str = ""
    unless hash.nil? or hash.count <= 1
      str << "<h5>#{header}</h5>"
      str << filter_checkboxes(hash, field_name)
    end
    raw str
  end
  def filter_checkboxes hash, field_name, options={}
    return "Geen verfijning mogelijk" if hash.nil?
    return "Niet van toepassing" if hash.count == 1

    options = { render_count: false }.merge(options)
    str = ""
    begin
      hash = hash.sort{|a,b| a[1][:name] <=> b[1][:name]}
    rescue ArgumentError
    end
    hash.each do | former_pair |
      value = former_pair[0]
      data = former_pair[1]
      str << filter_checkbox(field_name, value, data, options)
    end
    raw str
  end
  
  def reference
    @selection_filter
  end

  def filter_checkbox field_name, filter_value, data={}, options={}
    field_name = field_name.to_s
    field_name = field_name.gsub(".id","") if filter_value == :not_set
    i18n_scope = [:activerecord,:values,:work] << field_name.to_sym
    value_methods = filter_value.methods
    check_box_value = (value_methods.include?(:id) ? filter_value.id : filter_value)
    checked =  reference[field_name] && ( reference[field_name].include?(check_box_value) || reference[field_name].include?(check_box_value.to_s) || (filter_value == :not_set and reference[field_name].include?(nil)))

    label_tag do
      label_str = check_box_tag "filter[#{field_name}][]", check_box_value, checked
      if value_methods.include?(:name)
        label_str << data[:name]
      else
        begin
          label_str << I18n.t!(filter_value, scope: i18n_scope)
        rescue I18n::MissingTranslationData
          label_str << filter_value
        end
      end
      label_str << " (#{data[:count]})" if options[:render_count]
      label_str
    end
  end

  def options_from_aggregation_for_select aggregation, selected=nil
    html = ""
    aggregation.each do |k,v|
      # raise selected if selected.first.to_param == "3383330"
      selected_true = (selected and selected == k or (selected.methods.include?(:include?) and selected.collect{|a| a.to_param}.include?(k.to_param)))
      html += "<option value=\"#{k.to_param}\""
      html += "selected=\"selected\"" if selected_true
      html += ">#{v[:name]}</option>"
    end
    html.html_safe
  end
end
