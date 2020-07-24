# frozen_string_literal: true

module Artist::NameRenderer
  extend ActiveSupport::Concern

  included do
    def name(options = {})
      options = {include_years: true, include_locality: false, render_error: true}.merge(options)
      last_name_part = [first_name, prefix].join(" ").strip
      namepart = [last_name, last_name_part].delete_if(&:blank?).compact.join(", ")
      if artist_name.present? && namepart.present?
        namepart = "#{artist_name} (#{namepart})"
      elsif artist_name.present?
        namepart = artist_name
      end
      birth = options[:include_locality] && place_of_birth ? [place_of_birth, year_of_birth].join(", ") : year_of_birth
      death = options[:include_locality] && place_of_death ? [place_of_death, year_of_death].join(", ") : year_of_death
      birthpart = [birth, death].compact.join(" - ")
      birthpart = "(#{birthpart})" if birthpart != ""
      birthpart = "" if (options[:include_years] == false) && (options[:include_locality] == false)
      rname = [namepart, birthpart].delete_if { |a| a == "" }.join(" ")
      (rname == "") && options[:render_error] ? "-geen naam opgevoerd (#{id})-" : rname
    end

    def to_json_for_simple_artist return_pre_json = false
      obj = {first_name: first_name, last_name: last_name, prefix: prefix, year_of_birth: year_of_birth, year_of_death: year_of_death, place_of_birth: place_of_birth, place_of_death: place_of_death, artist_name: artist_name}.select { |k, v| !v.nil? }
      return_pre_json ? obj : obj.to_json
    end
  end

  class_methods do
    def to_json_for_simple_artist
      all.map { |a| a.to_json_for_simple_artist(true) }.to_json
    end
  end
end
