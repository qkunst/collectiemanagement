# frozen_string_literal: true

module WorksHelper
  # @params set [Hash] with object and counts
  def filter_checkboxes_with_header header, hash, field_name, options = {}
    str = ""
    unless hash.nil? || (hash.count <= 1)
      str += "<h5>#{header}</h5>"
      str += filter_checkboxes(hash, field_name)
    end
    raw str
  end

  def filter_checkboxes hash, field_name, options = {}
    return "Geen verfijning mogelijk" if hash.nil?
    return "Niet van toepassing" if hash.count == 1

    options = {render_count: false}.merge(options)
    str = ""
    begin
      hash = hash.sort { |a, b| a[1][:name] <=> b[1][:name] }
    rescue ArgumentError
    end
    hash.each do |former_pair|
      value = former_pair[0]
      data = former_pair[1]
      str += filter_checkbox(field_name, value, data, options)
    end
    raw str
  end

  def reference
    @selection_filter
  end

  def filter_checkbox field_name, filter_value, data = {}, options = {}
    field_name = field_name.to_s
    field_name = field_name.gsub(".id", "") if filter_value == Work::Search::NOT_SET_VALUE
    i18n_scope = [:activerecord, :values, :work] << field_name.to_sym
    value_methods = filter_value.methods
    check_box_value = (value_methods.include?(:id) ? filter_value.id : filter_value)
    checked = reference[field_name] && (reference[field_name].include?(check_box_value) || reference[field_name].include?(check_box_value.to_s) || ((filter_value == Work::Search::NOT_SET_VALUE) && reference[field_name].include?(nil)))

    label_tag do
      label_str = check_box_tag "filter[#{field_name}][]", check_box_value, checked
      if value_methods.include?(:name)
        label_str += data[:name]
      else
        begin
          label_str << I18n.t!(filter_value, scope: i18n_scope)
        rescue I18n::MissingTranslationData
          label_str << filter_value
        end
      end
      label_str += " (#{data[:count]})" if options[:render_count]
      label_str
    end
  end

  def filter_hidden field_name
    hidden_field_tag("filter[#{field_name}][]", reference[field_name]) if reference[field_name] && (reference[field_name] != "")
  end

  def options_from_aggregation_for_select aggregation, selected = nil
    html = ""
    aggregation.each do |k, v|
      selected_true = selected && (selected == k) || (selected.methods.include?(:include?) && selected.collect { |a| a.to_param }.include?(k.to_param))
      html += "<option value=\"#{k.to_param}\""
      html += "selected=\"selected\"" if selected_true
      html += ">#{v[:name]}</option>"
    end
    html.html_safe
  end

  def translate_works_with_article count
    I18n.translate "count.works_with_article", count: count
  end

  def translate_works count
    I18n.translate "count.works", count: count
  end

  def translate_inventoried_objects count
    I18n.translate "count.inventoried_objects_count", count: count
  end

  def translate_extended_count works
    count = works.try(:count_as_whole_works)
    inventoried_objects_count = works.count

    if count.nil? || count == inventoried_objects_count
      I18n.translate "count.works", count: inventoried_objects_count
    else
      "#{I18n.translate "count.works", count: count} (#{I18n.translate "count.inventoried_objects_count", count: inventoried_objects_count})"
    end
  end

  def describe_work_counts
    report = controller.is_a?(ReportController)

    filtered = @collection_works_count > @works_count
    grouped = @work_display_form && @work_display_form.group != :no_grouping
    more_inventoried_objects_than_works = @inventoried_objects_count != @works_count

    sentence_items = ["Deze collectie bevat #{translate_works(@collection_works_count)}"]

    if filtered
      sentence_items << ". Er"
      sentence_items << ((@works_count == 1 || report) ? " wordt " : " worden ")
      sentence_items << "vanwege een filter "
      sentence_items << (report ? "gerapporteerd over #{translate_works(@works_count)}" : "#{translate_works(@works_count)} getoond")
    end
    if more_inventoried_objects_than_works
      sentence_items += [", bestaande uit ", translate_inventoried_objects(@inventoried_objects_count)]
    end
    sentence_items << ". "
    if grouped
      sentence_items << "<span class=\"hide-for-screen\">Er is gegroepeerd op #{I18n.t(@work_display_form.group, scope: [:activerecord, :attributes, :work])}.</span>"
    end

    if params[:surface_calc]
      works = @works.to_a

      floor_surfaces = works.map(&:floor_surface).compact
      sentence_items << "</p><p>#{translate_works(floor_surfaces.count)} met een vloeroppervlak van in totaal #{floor_surfaces.sum}m². "

      wall_surfaces = works.map(&:wall_surface).compact
      sentence_items << "#{translate_works(wall_surfaces.count)} met een muuroppervlak van in totaal #{wall_surfaces.sum}m². "

      surface_less_works_count = works.count(&:surfaceless?)
      if surface_less_works_count > 0
        sentence_items << "#{translate_works(surface_less_works_count)} zonder oppervlak. "
      end
    end

    sanitize(sentence_items.join(""))
  end
end
