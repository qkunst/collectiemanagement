# frozen_string_literal: true

module Work::ParameterRerendering
  extend ActiveSupport::Concern

  included do
    def abstract_or_figurative_rendered
      if abstract_or_figurative?
        (abstract_or_figurative == "abstract") ? "Abstract" : "Figuratief"
      end
    end

    def artist_involvements_texts geoname_ids
      artists.collect { |a| a.artist_involvements.related_to_geoname_ids(geoname_ids) }.flatten.collect { |a| a.to_s(format: :short) }
    end

    def base_file_name
      stock_number? ? stock_number_file_safe : "AUTO_DB_ID_#{id}"
    end

    def cluster_name
      cluster&.name
    end

    def collection_locality_artist_involvements_texts
      collection_with_geoname_summaries = collection.self_or_parent_collection_with_geoname_summaries
      if collection_with_geoname_summaries
        artist_involvements_texts collection_with_geoname_summaries.cached_geoname_ids
      else
        []
      end
    end

    def collection_name_extended
      collection.cached_collection_name_extended
    end

    def condition_work_rendered
      rv = []
      rv.push(condition_work.name) if condition_work
      rv.push(damage_types.collect { |a| a.name }.join(", "))
      rv.push(condition_work_comments) if condition_work_comments?
      rv = rv.delete_if { |a| a.nil? || a == "" }.join("; ")
      rv if rv != ""
    end

    def condition_frame_rendered
      rv = []
      rv.push(condition_frame.name) if condition_frame
      rv.push(frame_damage_types.collect { |a| a.name }.join(", "))
      rv.push(condition_frame_comments) if condition_frame_comments?
      rv = rv.delete_if { |a| a.nil? || a == "" }.join("; ")
      rv if rv != ""
    end

    def hpd_keywords
      object_categories.collect { |a| a.name }.join(",")
    end

    def hpd_materials
      techniques.collect { |a| a.name }.join(",")
    end

    def hpd_condition
      condition_work_rendered
    end

    def hpd_photo_file_name
      "#{base_file_name}.jpg"
    end

    def hpd_comments
    end

    def hpd_contact
    end

    def location_raw
      if location && location.to_s.strip != ""
        location.strip
      else
        Work::Search::NOT_SET_VALUE
      end
    end

    def location_floor_raw
      if location_floor && location_floor.to_s.strip != ""
        [location_raw, location_floor.strip].join(Work::Search::JOIN_STRING_NESTED_VALUES)
      else
        [location_raw, Work::Search::NOT_SET_VALUE].join(Work::Search::JOIN_STRING_NESTED_VALUES)
      end
    end

    def location_detail_raw
      if location_detail && location_detail.to_s.strip != ""
        [location_floor_raw, location_detail.strip].join(Work::Search::JOIN_STRING_NESTED_VALUES)
      else
        [location_floor_raw, Work::Search::NOT_SET_VALUE].join(Work::Search::JOIN_STRING_NESTED_VALUES)
      end
    end

    def location_description
      rv = [location, location_floor, location_detail].compact.map(&:strip).filter(&:present?).join("; ")
      rv unless rv.blank?
    end

    def locality_geoname_name
      geoname_summary&.label
    end

    def market_value_range
      (market_value_min..market_value_max) if market_value_min && market_value_max
    end

    def name
      "#{artist_name_rendered} - #{title_rendered}"
    end

    def object_creation_year_rendered
      if object_creation_year_unknown && object_creation_year.nil?
        "Onbekend"
      else
        object_creation_year
      end
    end

    def print_rendered
      if print_unknown && self.print.blank?
        "Onbekend"
      else
        self.print
      end
    end

    def purchased_on_with_fallback
      purchased_on || purchase_year
    end

    def replacement_value_range
      (replacement_value_min..replacement_value_max) if replacement_value_min && replacement_value_max
    end

    def signature_rendered
      if no_signature_present && signature_comments.to_s.strip.empty?
        "Niet gesigneerd"
      else
        signature_comments unless signature_comments.to_s.strip.empty?
      end
    end

    def stock_number_file_safe
      stock_number.to_s.gsub(/[\/\\:]/, "-")
    end

    def title_rendered
      (title_nil = title.nil?) || title.to_s.strip.empty?
      if title_unknown && title_nil
        "Zonder titel"
      elsif title_nil
        "Nog geen titel"
      else
        read_attribute(:title)
      end
    end

    def title_with_year_rendered
      string = title_rendered
      string += " (#{object_creation_year})" if object_creation_year.present?
      string
    end
  end
end
