# frozen_string_literal: true

module Work::Search
  JOIN_STRING_NESTED_VALUES = "|>|"
  NOT_SET_VALUE = "not_set"

  extend ActiveSupport::Concern

  included do
    settings index: {number_of_shards: 5, max_result_window: 50_000} do
      mappings do
        indexes :abstract_or_figurative, type: "keyword"
        indexes :tag_list, type: "keyword"
        indexes :description, analyzer: "dutch", index_options: "offsets"
        indexes :grade_within_collection, type: "keyword"
        indexes :location_raw, type: "keyword"
        indexes :location_floor_raw, type: "keyword"
        indexes :location_detail_raw, type: "keyword"
        indexes :object_format_code, type: "keyword"
        indexes :availability_status, type: "keyword"
        indexes :report_val_sorted_artist_ids, type: "keyword"
        indexes :report_val_sorted_object_category_ids, type: "keyword"
        indexes :report_val_sorted_technique_ids, type: "keyword"
        indexes :title, analyzer: "dutch"
        indexes :market_value, type: "scaled_float", scaling_factor: 100
        indexes :replacement_value, type: "scaled_float", scaling_factor: 100
        indexes :market_value, type: "scaled_float", scaling_factor: 100
        indexes :purchase_price, type: "scaled_float", scaling_factor: 100
        indexes :market_value_min, type: "scaled_float", scaling_factor: 100
        indexes :market_value_max, type: "scaled_float", scaling_factor: 100
        indexes :replacement_value_min, type: "scaled_float", scaling_factor: 100
        indexes :replacement_value_max, type: "scaled_float", scaling_factor: 100
        indexes :minimum_bid, type: "scaled_float", scaling_factor: 100
        indexes :selling_price, type: "scaled_float", scaling_factor: 100
        indexes :purchase_price_in_eur, type: "scaled_float", scaling_factor: 100
      end
    end

    index_name "works-#{Rails.env.test? ? "testa" : "a"}"

    # for search
    def has_photo_front
      photo_front?
    end

    def as_indexed_json(*)
      index_config = {
        except: [:other_structured_data, :old_data, :photo_front, :photo_back, :photo_detail_1, :photo_detail_2],
        include: {
          artists: {only: [:id, :name], methods: [:name]},
          balance_category: {only: [:id, :name]},
          cluster: {only: [:id, :name]},
          condition_frame: {only: [:id, :name]},
          condition_work: {only: [:id, :name]},
          damage_types: {only: [:id, :name]},
          frame_damage_types: {only: [:id, :name]},
          medium: {only: [:id, :name]},
          object_categories: {only: [:id, :name]},
          owner: {only: [:id, :name]},
          placeability: {only: [:id, :name]},
          sources: {only: [:id, :name]},
          style: {only: [:id, :name]},
          subset: {only: [:id, :name]},
          techniques: {only: [:id, :name]},
          themes: {only: [:id, :name]},
          work_status: {only: [:id, :name]},
          work_sets: {only: [:id, :name]}
        },
        methods: [
          :tag_list, :geoname_ids, :title_rendered, :artist_name_rendered,
          :report_val_sorted_artist_ids, :report_val_sorted_object_category_ids, :report_val_sorted_technique_ids, :report_val_sorted_theme_ids,
          :location_raw, :location_floor_raw, :location_detail_raw, :for_rent, :for_purchase,
          :object_format_code, :inventoried, :refound, :new_found, :checked, :has_photo_front
        ]
      }

      if collection&.show_availability_status?
        index_config[:methods] << :availability_status
      end
      as_json(index_config)
    end
  end

  class_methods do
    def build_search_and_filter_query(search = "", filter = {}, options = {})
      options = {force_elastic: false, return_records: true, limit: 50_000, from: 0}.merge(options)
      base_collection = filter.delete(:collection)
      id_filter = Array(filter.delete(:id)) if filter[:id]
      sort = options[:sort] || ["_score"]

      query = {
        _source: [:id], # major speedup!
        from: options[:from],
        size: options[:limit],
        query: {
          bool: {
            must: []
          }
        },
        sort: sort
      }

      if base_collection
        query[:query][:bool][:must] << {terms: {
          "collection_id" => options[:no_child_works] ? [base_collection.id] : base_collection.expand_with_child_collections.pluck(:id)
        }}
      end

      if id_filter.is_a?(Array)
        query[:query][:bool][:must] << {terms: {id: id_filter}}
      end

      query[:query][:bool][:must] += search_to_elasticsearch_filter(search)
      query[:query][:bool][:must] += filter_to_elasticsearch_filter(filter)

      query[:aggs] = options[:aggregations] if options[:aggregations]
      query
    end

    def search_and_filter(search = "", filter = {}, options = {})
      collection = filter.delete(:collection)

      if search.blank? && !options[:force_elastic] && (filter.blank? || non_filter?(filter)) && collection
        return options[:no_child_works] ? collection.works.limit(options[:limit]) : collection.works_including_child_works.limit(options[:limit])
      end

      filter[:collection] = collection
      query = build_search_and_filter_query(search, filter, options)

      if options[:return_records]
        where(id: self.search(query).pluck("_id"))
      else
        self.search(query)
      end
    end

    private

    # the filter may contain some noise, also _and filtering is not relevant if there are no actual filter values
    def non_filter?(filter)
      if filter.is_a? Hash
        !filter.any? { |k, v| v.present? unless ["_and", "_invert"].include?(k) }
      end
    end

    def filter_to_elasticsearch_filter(filter_hash)
      invert = Array(filter_hash.delete("_invert"))
      and_filter = Array(filter_hash.delete("_and"))

      filter_hash.collect do |key, values|
        should_or_must_not = invert.include?(key) ? :must_not : :should

        new_bool = {
          bool: {
            should_or_must_not => []
          }
        }
        values.each do |value|
          new_bool[:bool][should_or_must_not] << if !value.nil?
            {term: {key => value}}
          else
            {bool: {must_not: {exists: {field: key}}}}
          end
        end
        if and_filter.include?(key)
          new_bool[:bool][:minimum_should_match] = values.count
        end
        new_bool
      end
    end

    def search_to_elasticsearch_filter(search)
      if search && !search.to_s.strip.empty?
        [{
          query_string: {
            default_field: "*",
            query: search,
            default_operator: :and,
            fuzziness: 1
          }
        }]
      else
        []
      end
    end
  end
end
