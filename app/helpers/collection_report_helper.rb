# frozen_string_literal: true

module CollectionReportHelper
  def report
    @report ||= @collection.report
  end

  def render_report_section(section_parts)
    html = ""
    section_parts.each do |report_section|
      html += "<table>"
      html += iterate_report_sections(report_section, report[report_section], 7)
      report.except!(report_section)
      html += "</table>"
    end
    html.gsub("<table></table>", "").html_safe
  end

  def link(group, selection)
    if selection.is_a?(Hash)
      group = group.to_s.gsub(/(.*)\_split$/, '\1')
      id_separator = "."
      id_separator = "_" unless group.to_s.ends_with?("s") || group.to_s.ends_with?("split")
      if selection.values.count == 0
        @params = @params.merge({"filter[#{group}][]" => :not_set})
        link_to("Niets ingevuld", collection_works_path(@collection, @params))
      else
        @params = @params.merge({"filter[#{group}][]" => nil})
        @params = @params.merge({"filter[#{group}#{id_separator}id]" => selection.keys})
        link_to(selection.values.to_sentence, collection_works_path(@collection, @params))
      end
    elsif [:image_rights, :publish, :abstract_or_figurative, :grade_within_collection, :object_creation_year, :purchase_year, :refound, :inventoried, :new_found].include?(group) || price_columns.include?(group)
      selection = selection.first if selection.is_a? Array
      if selection == :missing
        @params = @params.merge({"filter[#{group}][]" => :not_set})
        link_to("Niets ingevuld", collection_works_path(@collection, @params))
      else
        link_label = if price_columns.include?(group)
          number_to_currency(selection, precision: 0)
        else
          I18n.t(selection, scope: "activerecord.values.work.#{group}", default: selection)
        end

        @params = @params.merge({"filter[#{group}][]" => selection})
        link_to(link_label, collection_works_path(@collection, @params))
      end
    elsif [:location, :location_raw, :location_detail_raw, :location_floor_raw, :object_format_code, :tag_list].include? group
      @params = @params.merge({"filter[#{group}][]" => (selection == :missing ? :not_set : selection)})
      link_to((selection == :missing ? "#{I18n.t group.to_s.gsub(".keyword", ""), scope: "activerecord.attributes.work"} onbekend" : selection), collection_works_path(@collection, @params))
    elsif selection == :missing
      @params = @params.merge({"filter[#{group}.id]" => nil})
      @params = @params.merge({"filter[#{group}_id]" => nil})
      @params = @params.merge({"filter[#{group}][]" => :not_set})
      link_to("Niets ingevuld", collection_works_path(@collection, @params))
    else
      selection.to_s
    end
  end

  def render_spacers(depth)
    html = ""
    (6 - depth).times do
      html += "<td class=\"spacer\"></td>"
    end
    html
  end

  def iterate_report_sections(section_head, section, depth)
    if section && (section.keys.count > 0)
      html = "<tr class=\"section #{section_head.to_s.gsub(".keyword", "")} span-#{depth}\">"
      html += render_spacers(depth)
      html += "<th colspan=\"#{depth + 1}\">#{I18n.t section_head.to_s.gsub(".keyword", ""), scope: "activerecord.attributes.work"}</th>"
      html += "</tr>\n"
      html += iterate_groups(section_head, section, depth - 1)
      html
    else
      ""
    end
  end

  def price_columns
    [:replacement_value, :replacement_value_min, :purchase_price_in_eur, :replacement_value_max, :market_value, :market_value_min, :market_value_max, :minimum_bid, :selling_price]
  end

  def iterate_groups(group, contents, depth)
    html = ""
    if depth > 0
      if contents
        contents = if [:object_creation_year, :purchase_year, :refound, :inventoried, :new_found].include?(group) || price_columns.include?(group)
          contents.sort { |a, b| b[0][0].to_i <=> a[0][0].to_i }
        elsif [:grade_within_collection].include? group
          contents.sort { |a, b| a[0].to_s <=> b[0].to_s }
        else
          contents.sort { |a, b| b[1][:count] <=> a[1][:count] }
        end
        if price_columns.include?(group)
          total = contents.sum { |a| a[0][0].to_i * a[1][:count] }
          html += "<tfoot><tr><td  class=\"count\" colspan=\"6\">Totaal:</td><td class=\"count\">#{number_to_currency(total, precision: 0)}</td></tr></tfoot>"
        end
        contents.each do |s|
          sk = s[0]
          sv = s[1]
          @params = {} if depth == 6
          sk = link(group, sk)
          html += "<tr class=\"content span-#{depth}\">"
          html += render_spacers(depth)
          html += "<td colspan=\"#{depth}\">#{sk}</td><td class=\"count\">#{sv[:count]}</td></tr>\n"
          sv[:subs].each do |subbucketgroupname, subbucketgroup|
            html += iterate_report_sections(subbucketgroupname, subbucketgroup, (depth - 1))
          end
        end
      end
      html += "<tr class=\"group_separator\"><td colspan=\"7\"></td></tr>"
      @params.delete(@params.keys.last)
    end
    html
  end
end
