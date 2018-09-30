module Work::ParameterRerendering
  extend ActiveSupport::Concern

  included do
    def hpd_height
      rv = frame_height? ? frame_height : height
      rv if rv and rv > 0
    end
    def hpd_width
      rv = frame_width? ? frame_width : width
      rv if rv and rv > 0
    end
    def hpd_depth
      rv = frame_depth? ? frame_depth : depth
      rv if rv and rv > 0
    end
    def hpd_diameter
      rv = frame_diameter? ? frame_diameter : diameter
      rv if rv and rv > 0
    end
    def hpd_keywords
       object_categories.collect{|a| a.name}.join(",")
    end
    def hpd_materials
       techniques.collect{|a| a.name}.join(",")
    end
    def hpd_condition
      condition_work_rendered
    end
    def stock_number_file_safe
      stock_number.to_s.gsub(/[\/\\\:]/,"-")
    end
    def base_file_name
      stock_number? ? stock_number_file_safe : "AUTO_DB_ID_#{id}"
    end
    def hpd_photo_file_name
      "#{base_file_name}.jpg"
    end
    def hpd_comments
    end
    def hpd_contact
    end
    def title_rendered
      title_nil = title.nil? or title.to_s.strip.empty?
      if title_unknown and title_nil
        return "Zonder titel"
      elsif title_nil
        return "Nog geen titel"
      else
        return read_attribute(:title)
      end
    end

    def name
      "#{artist_name_rendered} - #{title_rendered}"
    end

    def location_raw
      location if location && location.to_s.strip != ""
    end
    def location_floor_raw
      location_floor if location_floor && location_floor.to_s.strip != ""
    end
    def location_detail_raw
      location_detail if location_detail && location_detail.to_s.strip != ""
    end

    def abstract_or_figurative_rendered
      if abstract_or_figurative?
        return abstract_or_figurative == "abstract" ? "Abstract" : "Figuratief"
      end
    end

    def locality_geoname_name
      gs = GeonameSummary.where(geoname_id: locality_geoname_id).first
      return gs.label if gs
    end

    def purchased_on_with_fallback
      return purchased_on if purchased_on
      return purchase_year if purchase_year
    end
    def signature_rendered
      if no_signature_present and signature_comments.to_s.strip.empty?
        "Niet gesigneerd"
      else
        signature_comments unless signature_comments.to_s.strip.empty?
      end
    end

    def object_creation_year_rendered
      if object_creation_year_unknown and object_creation_year.nil?
        "Onbekend"
      else
        object_creation_year
      end
    end
    def condition_work_rendered
      rv = []
      rv.push(condition_work.name) if condition_work
      rv.push(damage_types.collect{|a| a.name}.join(", ")) if damage_types.count > 0
      rv.push(condition_work_comments) if condition_work_comments?
      rv = rv.join("; ")
      return rv if rv != ""
    end

    def condition_frame_rendered
      rv = []
      rv.push(condition_frame.name) if condition_frame
      rv.push(frame_damage_types.collect{|a| a.name}.join(", ")) if frame_damage_types.count > 0
      rv.push(condition_frame_comments) if condition_frame_comments?
      rv = rv.join("; ")
      return rv if rv != ""
    end
    def whd_to_s width=nil, height=nil, depth=nil, diameter=nil
      whd_values = [width, height, depth].collect{|a| dimension_to_s(a)}.compact
      rv = whd_values.join(" × ")
      if whd_values.count > 0
        legend = []
        legend << "b" unless width.to_s == ""
        legend << "h" unless height.to_s == ""
        legend << "d" unless depth.to_s == ""
        rv = "#{rv} (#{legend.join("×")})"
      end
      rv = [rv, "⌀ #{dimension_to_s(diameter)}"].compact.join("; ") if dimension_to_s(diameter)
      return nil if rv.empty?
      rv
    end
    def frame_size
      whd_to_s(frame_width, frame_height, frame_depth, frame_diameter)
    end

    def work_size
      whd_to_s(width, height, depth, diameter)
    end

    def frame_size_with_fallback
      frame_size || work_size
    end

    def collection_name_extended
      self.collection.collection_name_extended
    end
    def object_format_code
      size = [hpd_height,hpd_width,hpd_depth,hpd_diameter].compact.max
      if !size
      elsif size < 30
        :xs
      elsif size < 50
        :s
      elsif size < 80
        :m
      elsif size < 120
        :l
      elsif size >= 120
        :xl
      end
    end

    def cluster_name
      cluster.name if cluster
    end
  end
end