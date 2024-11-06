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
          },
          artists: {
            terms: {
              field: "report_val_sorted_artist_ids", size: 10_000
            }
          },
          object_categories: {
            terms: {
              field: "report_val_sorted_object_category_ids", size: 999
            },
            aggs: {
              techniques: {
                terms: {
                  field: "report_val_sorted_technique_ids", size: 999
                }
              },
              techniques_missing: {
                missing: {
                  field: "report_val_sorted_technique_ids"
                }
              }
            }
          },

          object_categories_split: {
            terms: {
              field: "report_val_sorted_object_category_ids", size: 999
            },
            aggs: {
              techniques: {
                terms: {
                  field: "techniques.id", size: 999
                }
              },
              techniques_missing: {
                missing: {
                  field: "techniques.id"
                }
              }
            }
          }
        }

        [:subset, :style, :frame_type].each do |key|
          aggregation.merge!(basic_aggregation_snippet(key, "_id"))
        end

        [:condition_work, :condition_frame, :sources, :placeability, :themes, :owner, :cluster, :work_status].each do |key|
          aggregation.merge!(basic_aggregation_snippet_with_missing(key, ".id"))
        end

        [:damage_types, :frame_damage_types, :work_sets].each do |key|
          aggregation.merge!(basic_aggregation_snippet(key, ".id"))
        end

        ["abstract_or_figurative", "grade_within_collection", "object_format_code", "tag_list", :object_creation_year, :purchase_year, :purchase_price_in_eur, :minimum_bid, :selling_price, :publish, :image_rights, :permanently_fixed].each do |key|
          aggregation.merge!(basic_aggregation_snippet_with_missing(key))
        end

        [:market_value, :replacement_value, :inventoried, :refound, :new_found, :checked, :has_photo_front, :availability_status, :for_purchase, :for_rent].each do |key|
          aggregation.merge!(basic_aggregation_snippet(key))
        end

        market_value_range = basic_aggregation_snippet(:market_value_range, "", :market_value_min)
        market_value_range[:market_value_range][:aggs] = basic_aggregation_snippet(:market_value_max)
        aggregation.merge!(market_value_range)

        replacement_value_range = basic_aggregation_snippet(:replacement_value_range, "", :replacement_value_min)
        replacement_value_range[:replacement_value_range][:aggs] = basic_aggregation_snippet(:replacement_value_max)
        aggregation.merge!(replacement_value_range)

        aggregation[:market_value_min_ignore_super_missing] = {
          missing: {field: :market_value_min},
          aggs: {
            market_value_ignore_super_missing: {
              missing: {field: :market_value},
              aggs: basic_aggregation_snippet_with_missing(:balance_category, ".id")
            }
          }
        }

        aggregation[:replacement_value_min_ignore_super_missing] = {
          missing: {field: :replacement_value_min},
          aggs: {
            replacement_value_ignore_super_missing: {
              missing: {field: :replacement_value},
              aggs: {
                missing_explainer_missing: {
                  missing: {field: :replacement_value}
                }
              }
            }
          }
        }

        location_sub_sub = basic_aggregation_snippet(:location_detail_raw)

        location_sub = basic_aggregation_snippet(:location_floor_raw)
        location_sub.keys.each do |key|
          location_sub[key][:aggs] = location_sub_sub
        end

        location = basic_aggregation_snippet(:location_raw)
        location.keys.each do |key|
          location[key][:aggs] = location_sub
        end

        aggregation.merge!(location)

        aggregation
      end
    end
  end
end
