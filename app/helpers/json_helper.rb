# frozen_string_literal: true

module JsonHelper
  def clean_key key
    key = key.to_s.strip
    return "" if key.ends_with?("_lref") || key.ends_with?("_search") || key.ends_with?("earchField") || key.starts_with?("filterField") || ["allowedproductstrings", "suggested", "urls", "url", "displaydatabase", "displayrole", "field", "count", "database"].include?(key.downcase)
    key.tr("_", " ").capitalize
  end

  def render_hash json, options = {}
    html = ""
    if json.methods.include? :keys
      html += "<dl>"
      json.each do |k, v|
        html += "<dt>#{clean_key(k)}</dt><dd>#{render_hash(v)}</dd>" unless render_hash(v).empty? || clean_key(k).empty?
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
      html += json.to_s.strip
    end
    html.html_safe
  end

  def simple_format_value value
    sanitize value.to_s.gsub(/\s\d\d:\d\d:\d\d\sUTC/, "").gsub(/^false$/, "uit").gsub(/^true$/, "aan")
  end

  def render_object_changes_json json
    ignore_keys = Work::INSIGNIFICANT_FIELDS.map(&:to_s)
    html_bits = []

    first = true

    json.each do |key, values|
      unless ignore_keys.include?(key)
        key_human = Work.human_attribute_name(key.gsub(/_id$/, ""))
        if !first
          key_human = key_human.downcase
          first = false
        end
        key_human_formatted = "<strong>#{key_human}</strong>"

        html_bits << if key.ends_with? "_id"
          "#{key_human_formatted} gewijzigd"
        elsif key.starts_with? "photo_"
          "#{key_human_formatted} #{values[0].blank? ? "toegevoegd" : "gewijzigd"}"
        elsif values[0].blank?
          "#{key_human_formatted} #{simple_format_value(values[1].to_s)}"
        else
          "#{key_human_formatted} <s>#{simple_format_value(values[0].to_s)}</s>#{simple_format_value(values[1].to_s)}"
        end
      end
    end
    html_bits.to_sentence.html_safe
  end
end
