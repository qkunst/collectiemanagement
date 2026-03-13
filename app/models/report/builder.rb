# frozen_string_literal: true

module Report
  class Builder
    extend Report::BuilderHelpers

    class << self
      def fields_without_aggregates
        aggregations.select { |k, v| !v.key?(:aggs) }.keys
      end

      def aggregations
        aggregation = {
          total: {
            value_count: {
              field: :id
            }
          }
        }

        aggregation.merge!(basic_aggregation_snippet(:object_categories, field: :report_val_sorted_object_category_ids) do
          basic_aggregation_snippet(:techniques, include_missing: true, field: :report_val_sorted_technique_ids)
        end)
        aggregation.merge!(basic_aggregation_snippet(:object_categories_split, field: :report_val_sorted_object_category_ids) do
          basic_aggregation_snippet(:techniques, include_missing: true, postfix: ".id")
        end)
        aggregation.merge!(basic_aggregation_snippet(:artists, field: :report_val_sorted_artist_ids, size: 10_000))

        [:subset, :style, :frame_type].each do |key|
          aggregation.merge!(basic_aggregation_snippet(key, postfix: "_id"))
        end

        [:condition_work, :condition_frame, :sources, :placeability, :themes, :owner, :cluster, :work_status, :balance_category].each do |key|
          aggregation.merge!(basic_aggregation_snippet(key, include_missing: true, postfix: ".id"))
        end

        [:damage_types, :frame_damage_types, :work_sets].each do |key|
          aggregation.merge!(basic_aggregation_snippet(key, postfix: ".id"))
        end

        [:market_value, :replacement_value, :abstract_or_figurative, :grade_within_collection, :object_format_code, :tag_list, :object_creation_year, :purchase_year, :purchase_price_in_eur, :minimum_bid, :selling_price, :publish, :image_rights, :permanently_fixed].each do |key|
          aggregation.merge!(basic_aggregation_snippet(key, include_missing: true))
        end

        [:inventoried, :refound, :new_found, :checked, :has_photo_front, :availability_status, :for_purchase, :for_rent].each do |key|
          aggregation.merge!(basic_aggregation_snippet(key))
        end

        aggregation.merge!(basic_aggregation_snippet(:market_value_range, field: :market_value_min, include_missing: true) { basic_aggregation_snippet(:market_value_max) })
        aggregation.merge!(basic_aggregation_snippet(:replacement_value_range, field: :replacement_value_min) { basic_aggregation_snippet(:replacement_value_max) })

        aggregation.merge!(basic_aggregation_snippet(:location_raw) do
          basic_aggregation_snippet(:location_floor_raw) do
            basic_aggregation_snippet(:location_detail_raw)
          end
        end)

        aggregation
      end
    end
  end
end
