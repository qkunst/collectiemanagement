module CollectionsHelper
  def report
    @report ||= @collection.report

  end
  def render_report_section(section_parts)
    html = "<table>"
    section_parts.each do |report_section|
      html += iterate_report_sections(report_section,report[report_section],6)
      report.except!(report_section)
    end
    html += "</table>"
    return html.html_safe
  end

  def link(group,selection)
    if selection.is_a?(Hash)
      group = group.to_s.gsub(/(.*)\_split$/,'\1')
      id_separator = "."
      id_separator = "_" unless group.to_s.ends_with?("s") or group.to_s.ends_with?("split") #or [:style].include?(group) #([:arti].include?(group)) ? "_" : "."
      @params = @params.merge({"filter[#{group}#{id_separator}id]"=>selection.keys})
      link_to(selection.values.to_sentence,collection_works_path(@collection, @params))
    elsif [:image_rights, :publish, :abstract_or_figurative, :grade_within_collection, :object_format_code, :replacement_value, :market_value, :object_creation_year, :purchase_year].include? group
      selection = selection.first if selection.is_a? Array
      if selection == :missing
        @params = @params.merge({"filter[#{group}][]"=>:not_set})
        link_to("Niets ingevuld",collection_works_path(@collection, @params))
      else
        @params = @params.merge({"filter[#{group}][]"=>selection})
        link_to(I18n.t(selection, scope: "activerecord.values.work.#{group}", default: selection),collection_works_path(@collection, @params))
      end
    elsif [:location, :location_raw].include? group
      @params = @params.merge({"filter[#{group}][]"=>(selection == :missing ? :not_set : selection)})
      link_to((selection == :missing ? "Locatie onbekend" : selection),collection_works_path(@collection, @params))
    elsif selection == :missing
      @params = @params.merge({"filter[#{group}][]"=>:not_set})
      link_to("Niets ingevuld",collection_works_path(@collection, @params))
    else
      selection
    end

  end

  def render_spacers(depth)
    html=""
    (6-depth).times do
      html+="<td class=\"spacer\"></td>"
    end
    html
  end

  def iterate_report_sections(section_head, section, depth)
    if section and section.keys.count > 0
      html = "<tr class=\"section #{section_head}\">"
      html += render_spacers(depth)
      html += "<th colspan=\"#{depth+1}\">#{I18n.t section_head, scope: "activerecord.attributes.work"}</th>"
      html += "</tr>"
      html += iterate_groups(section_head,section,depth-1)
      html
    else
      ""
    end
  end

  def iterate_groups(group, contents,depth)
    html=""
    if depth > 0
      # raise contents
      if contents
        if [:replacement_value, :market_value, :object_creation_year, :purchase_year].include? group
          contents = contents.collect{|a| a}.sort{|a,b| (b[0][0].to_i)<=>(a[0][0].to_i)}
        elsif [:grade_within_collection].include? group
          contents = contents.collect{|a| a}.sort{|a,b| (a[0].to_s)<=>(b[0].to_s)}
        else
          contents = contents.sort{|a,b| b[1][:count]<=>a[1][:count]}
        end
        contents.each do |s|
          sk = s[0]
          sv = s[1]
          @params={} if depth == 5
          sk = link(group,sk)
          html += "<tr class=\"content\""
          html +=">"
          html += render_spacers(depth)
          html += "<td colspan=\"#{depth}\">#{sk}</td><td class=\"count\">#{sv[:count]}</td></tr>"
          sv[:subs].each do |subbucketgroupname, subbucketgroup|
            html += iterate_report_sections(subbucketgroupname, subbucketgroup, (depth-1))
          end
        end
      end
      html += "<tr class=\"group_separator\"><td colspan=\"7\"></td</tr>"
    end
    return html
  end

end

