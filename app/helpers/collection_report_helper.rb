# frozen_string_literal: true

module CollectionReportHelper
  BOOLEANS = [:image_rights, :publish, :abstract_or_figurative, :grade_within_collection]
  PRICE_COLUMNS = [:replacement_value, :replacement_value_min, :purchase_price_in_eur, :replacement_value_max, :market_value, :market_value_min, :market_value_max, :minimum_bid, :selling_price]
  DATE_OR_TIME_COLUMNS = [:object_creation_year, :purchase_year, :refound, :inventoried, :new_found]

  RANGE_GROUP = [:market_value_range, :replacement_value_range]

  DEEPEST = 6

  def report
    @report ||= @collection.report
  end

  def render_report_column(sections)
    html = ""
    sections.each do |report_section|
      html += "<table>"
      html += iterate_report_sections(report_section, report[report_section], DEEPEST + 1)
      report.except!(report_section)
      html += "</table>"
    end
    html.gsub("<table></table>", "").html_safe
  end

  def missing_link_label(group)
    if [:location, :location_raw, :location_detail_raw, :location_floor_raw, :object_format_code].include? group
      "#{I18n.t group.to_s.gsub(".keyword", ""), scope: "activerecord.attributes.work"} onbekend"
    elsif group == :balance_category
      "Zonder toelichting"
    else
      "Niets ingevuld"
    end
  end

  def filter_check_box(filter_params)
    @selection_filter ||= {}

    present_filter_params = filter_params.select { |k, v| v.present? }
    present_filter_param = present_filter_params.to_a.last

    param_name = present_filter_param[0]
    field_name = param_name.sub(/filter\[/, "").gsub(/[\[\]]/, "")

    value = present_filter_param[1]

    if value.is_a?(Array)
      url_param_name = "#{param_name}[]"
      url_param_value = present_filter_param[1].first
    else
      url_param_name = param_name
      url_param_value = value
    end

    param_value = value == :not_set ? nil : url_param_value

    selected_filter_value_for_name = @selection_filter[field_name]

    checked = if selected_filter_value_for_name.is_a?(Array)
      selected_filter_value_for_name.map do |a|
        if a == true
          1
        elsif a == false
          0
        else
          a
        end
      end.include?(param_value)
    else
      @selection_filter.key?(field_name) && selected_filter_value_for_name == param_value
    end

    parent_json = [filter_params.select { |k, v| k != param_name }.to_a.last].compact.to_h.to_json
    if show_filter_check_boxes
      check_box_tag(url_param_name, url_param_value, checked, data: {parent: parent_json})
    end
  end

  def link(group, selection)
    link_label = selection

    if selection == :missing || (selection.is_a?(Hash) && selection.values.count == 0)
      @params.delete("filter[#{group}.id]")
      @params.delete("filter[#{group}_id]")
      @params["filter[#{group}][]"] = :not_set

      link_label = missing_link_label(group)
    elsif selection.is_a?(Hash)
      group = group.to_s.gsub(/(.*)_split$/, '\1')
      id_separator = "."
      id_separator = "_" unless group.to_s.ends_with?("s") || group.to_s.ends_with?("split")
      @params.delete("filter[#{group}][]")
      @params["filter[#{group}#{id_separator}id]"] = selection.keys

      link_label = selection.values.to_sentence
    else
      selection = selection.first if selection.is_a? Array
      link_label = if PRICE_COLUMNS.include?(group)
        number_to_currency(selection, precision: 0)
      else
        I18n.t(selection, scope: "activerecord.values.work.#{group}", default: selection)
      end
      @params["filter[#{group}][]"] = selection
    end

    [filter_check_box(@params), link_to(link_label, collection_works_path(@collection, @params))].join("").html_safe
  end

  def render_spacers(depth)
    html = ""
    (DEEPEST - depth).times do
      html += "<td class=\"spacer\"></td>"
    end
    html
  end

  def iterate_report_sections(section_head, section, depth)
    if section && (section.keys.count > 0)
      html = ""
      unless ignore_super?(section_head)
        html = "<tr class=\"section #{section_head.to_s.gsub(".keyword", "")} span-#{depth}\">"
        html += render_spacers(depth)
        html += "<th colspan=\"#{depth + 1}\">#{titleize_section_head section_head}</th>"
        html += "</tr>\n"
      end
      html += iterate_groups(section_head, section, depth - 1)
      html
    else
      ""
    end
  end

  def titleize_section_head(section_head)
    title_translation_key = section_head.to_s.gsub(".keyword", "")
    default_title = I18n.t(title_translation_key, scope: "activerecord.attributes.work")
    I18n.t(title_translation_key, scope: "report.titles", default: default_title)
  end

  def sort_contents_by_group(contents, group)
    if DATE_OR_TIME_COLUMNS.include?(group) || PRICE_COLUMNS.include?(group) || RANGE_GROUP.include?(group)
      contents.sort { |a, b| b[0][0].to_i <=> a[0][0].to_i }
    elsif [:grade_within_collection].include? group
      contents.sort { |a, b| a[0].to_s <=> b[0].to_s }
    else
      contents.sort { |a, b| b[1][:count] <=> a[1][:count] }
    end
  end

  def range?(group)
    group.to_s.ends_with?("_range")
  end

  def ignore_super?(group)
    group.to_s.ends_with?("_ignore_super")
  end

  def min_range_column(group)
    group.to_s.sub(/_ignore_super$/, "").sub(/_range$/, "_min").to_sym
  end

  def max_range_column(group)
    group.to_s.sub(/_ignore_super$/, "").sub(/_range$/, "_max").to_sym
  end

  def iterate_groups(group, contents, depth)
    html = ""
    if contents && depth > 0
      contents = sort_contents_by_group(contents, group)
      if range?(group) && depth == DEEPEST
        html += render_range(contents, group)
      else
        if PRICE_COLUMNS.include?(group)
          total = contents.sum { |a| a[0][0].to_i * a[1][:count] }
          html += "<tfoot><tr><td  class=\"count\" colspan=\"#{DEEPEST}\">Totaal:</td><td class=\"count\">#{number_to_currency(total, precision: 0)}</td></tr></tfoot>"
        end
        contents.each do |s|
          sk = s[0]
          sv = s[1]
          @params = {} if depth == DEEPEST
          sk = link(min_range_column(group), sk)
          hidden = ignore_super?(group)
          group_hash = @params.to_a
          group_hash.pop

          html += "<tr class=\"content span-#{depth} #{hidden ? "hide" : ""}\" data-group=\"#{Digest::MD5.hexdigest(group_hash.to_s)}\">"
          html += render_spacers(depth)
          html += "<td colspan=\"#{depth}\">#{sk}</td><td class=\"count\">#{sv[:count]}</td></tr>\n"
          sv[:subs].each do |subbucketgroupname, subbucketgroup|
            html += iterate_report_sections(subbucketgroupname, subbucketgroup, (depth - 1))
          end
        end
      end
      html += "<tr class=\"group_separator\"><td colspan=\"7\"></td></tr>\n"
      @params.delete(@params.keys.last)
    end
    html
  end

  def render_range(contents, group)
    html = ""
    contents_with_values = contents.select { |a| a.dig(1, :subs, max_range_column(group)) }
    range_counts = contents_with_values.flat_map { |set|
      min_value = set.dig(0, 0)
      set.dig(1, :subs, max_range_column(group)).map do |k, v|
        {min: min_value, max: k.first, count: v[:count]}
      end
    }
    total_min = range_counts.sum { |c| c[:min] * c[:count] }
    total_max = range_counts.sum { |c| c[:max] * c[:count] }

    html += "<tfoot>"
    html += "<tr><td class=\"count\" colspan=\"7\">Totaal: #{number_to_currency(total_min, precision: 0)} - #{number_to_currency(total_max, precision: 0)}</td></tr>"
    html += "</tfoot>"

    range_counts.each do |range_count|
      start_key = range_count[:min]
      finish_key = range_count[:max]
      finish_count = range_count[:count]
      @params = {"filter[#{min_range_column(group)}][]" => range_count[:min], "filter[#{max_range_column(group)}][]" => range_count[:max]}

      link_label = "#{number_to_currency(start_key, precision: 0)} - #{number_to_currency(finish_key, precision: 0)}"
      link = [filter_check_box(@params), link_to(link_label, collection_works_path(@collection, @params))].join("").html_safe
      html += "<tr><td colspan=\"#{DEEPEST}\">#{link}</td><td class=\"count\">#{finish_count}</td></tr>"
    end

    # make sure missing counts are added as well
    contents.each do |start|
      @params = {}
      group = max_range_column(group)
      if start[1][:subs] == {} || start[0] == :missing
        html += "<tr><td colspan=\"#{DEEPEST}\">#{link(group, start[0])}</td><td class=\"count\">#{start[1][:count]}</td></tr>"
      end
    end

    html
  end

  def show_filter_check_boxes
    @show_filter_check_boxes
  end
end
