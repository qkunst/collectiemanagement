# frozen_string_literal: true

# == Schema Information
#
# Table name: geoname_summaries
#
#  id                       :bigint           not null, primary key
#  geoname_ids              :string
#  language                 :string
#  name                     :string
#  parent_description       :string
#  parent_geoname_ids_cache :text
#  type_code                :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  geoname_id               :bigint
#
# Indexes
#
#  index_geoname_summaries_on_geoname_id               (geoname_id)
#  index_geoname_summaries_on_geoname_id_and_language  (geoname_id,language)
#
class GeonameSummary < ApplicationRecord
  include MethodCache

  scope :selectable, -> { where(type_code: ["AREA", "PPL", "PPLA", "PPLA2", "PPLC", "PPLG", "COUNTRY", "ADM1", "ISL"]) }

  has_cache_for_method :parent_geoname_ids

  before_save :cache_parent_geoname_ids

  def to_s
    "#<GeonameSummary id=#{id} name=\"#{name}\" type_code=#{type_code} desc=\"#{parent_description&.[](0..30)}\">"
  end

  def label
    "#{name} (#{parent_description})".gsub("()", "").strip
  end

  def priority
    base = 0
    base += 1 if parent_description[0..1] == "NL"
    base += 1 if ["PPLC", "PPLG"].include? type_code
    base -= 1 if ["PPLL"].include? type_code
    base
  end

  def geoname_ids= array
    write_attribute(:geoname_ids, array.join(","))
  end

  def geoname_ids
    read_attribute(:geoname_ids).split(",").collect { |a| a.to_i }
  end

  def parent_geoname_ids
    base = Geoname.find_by(geonameid: geoname_id) || GeonamesAdmindiv.find_by(geonameid: geoname_id) || GeonamesCountry.find_by(geoname_id: geoname_id)
    base ? base.parent_geoname_ids : []
  end

  def parents
    GeonameSummary.where(geoname_id: parent_geoname_ids)
  end

  def to_param
    geoname_id.to_s
  end

  def <=> other
    other.priority <=> priority
  end

  class << self
    def with_parents
      ids = []
      all.each do |a|
        ids += a.cached_parent_geoname_ids
        ids << a.geoname_id
      end
      GeonameSummary.unscoped.where(geoname_id: ids.compact.uniq)
    end

    def search name
      if name.nil? || name.to_s.empty?
        return []
      end
      results = selectable.where(arel_table[:name].matches(name))
      if results.count > 0
        return results.sort
      end

      if /\((.*)\)/.match?(name)
        description = name.match(/\((.*)\)/)[1]
        name = name.gsub(/\((.*)\)/, "").strip
        results = selectable.where(arel_table[:name].matches(name))
        return results.select { |a| a.parent_description.match(description) }
      end

      # results = self.selectable.where(arel_table[:name].matches("%#{name}%"))
      # return results.sort if results.count > 1
      []
    end

    def to_array
      all.collect { |a| {id: a.geoname_id, name: a.name, desc: a.parent_description} }
    end

    def to_hash
      h = {}
      all.each do |summ|
        h[summ.geoname_id] = {name: summ.name, desc: summ.parent_description}
      end
      h
    end
  end
end
