# frozen_string_literal: true

module FastAggregatable
  extend ActiveSupport::Concern

  class_methods do
    def fast_aggregations attributes
      rv = {}
      attributes.each do |attribute|
        rv[attribute] ||= {}
        attribute_id = "#{attribute}_id"
        if column_names.include? attribute.to_s
          _fast_aggregate_column_values(rv, attribute)
        elsif column_names.include? attribute_id
          _fast_aggregate_belongs_to_values(rv, attribute)
        elsif attribute == :geoname_ids
          _fast_aggregate_geoname_ids(rv)
        elsif Work.new.methods.include? attribute.to_sym
          _fast_aggregate_belongs_to_many rv, attribute
        end
      end
      rv
    end
    private def _fast_aggregate_column_values rv, attribute
      self.select(attribute).group(attribute).collect { |a| a.send(attribute) }.sort_by(&:to_s).each do |a|
        value = (a || :not_set)
        if value.is_a? String
          if attribute == :grade_within_collection
            value = value[0]
          end
        end
        rv[attribute][value] ||= {count: 999999, name: value}
      end
      rv
    end
    private def _fast_aggregate_belongs_to_values rv, attribute
      attribute_id = "#{attribute}_id"
      # Can ignore the brakeman warning on SQL injection
      # the attribute will have to be a valid column name
      ids = group(attribute_id).select(attribute_id).collect { |a| a.send(attribute_id) }
      if ids.include? nil
        rv[attribute][:not_set] ||= {count: 999999, name: :not_set}
      end
      attribute.to_s.classify.constantize.where(id: [ids]).each do |a|
        rv[attribute][a] ||= {count: 20000, name: a.name}
      end
      rv
    end
    private def _fast_aggregate_belongs_to_many rv, attribute
      attribute_id = "#{attribute}.id"
      # Can ignore the brakeman warning on SQL injection
      # the attribute will have to be a valid column name
      ids = left_outer_joins(attribute).select("#{attribute_id} AS id").distinct.collect(&:id)
      if ids.include? nil
        rv[attribute][:not_set] ||= {count: 999999, name: :not_set}
      end
      attribute.to_s.classify.constantize.where(id: [ids]).each do |a|
        rv[attribute][a] ||= {count: 999999, name: a.name}
      end
    end
    private def _fast_aggregate_geoname_ids rv
      ids = group(:locality_geoname_id).select(:locality_geoname_id).collect { |a| a.locality_geoname_id }.compact.uniq
      artists = Artist.where(id: joins(:artists).select("artist_id AS id").collect { |a| a.id }).distinct
      artists.each do |artist|
        ids += Array(artist.cached_geoname_ids)
      end
      ids = ids.compact.uniq
      GeonameSummary.where(geoname_id: ids).with_parents.each do |geoname|
        rv[:geoname_ids][geoname] = {count: 20000, name: geoname.name}
      end
      rv
    end
  end
end
