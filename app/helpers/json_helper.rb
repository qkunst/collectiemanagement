# frozen_string_literal: true

module JsonHelper
  def clean_key key
    key = key.to_s.strip
    return "" if key.ends_with?('_lref') or key.ends_with?('_search') or key.ends_with?('earchField') or key.starts_with?('filterField')  or ["allowedproductstrings","suggested", "urls", "url", "displaydatabase", "displayrole", "field", "count", "database"].include? key.downcase
    return key.gsub('_',' ').capitalize
  end

  def render_hash json, options={}
    html = ""
    if json.methods.include? :keys
      html += "<dl>"
      json.each do |k, v|
        html += "<dt>#{clean_key(k)}</dt><dd>#{render_hash(v)}</dd>" unless render_hash(v).empty? or clean_key(k).empty?
      end
      html += "</dl>"
      html = "" if html == "<dl></dl>"
    elsif json.methods.include? :each
      html = "<ul>"
      json.each do |k|
        html += "<li>#{render_hash(k)}</li>" unless render_hash(k).empty?
      end
      html += "</ul>"
      html = "" if html == "<ul></ul>"
    else
      html += "#{json}".strip
    end
    html.html_safe
  end
end
