# frozen_string_literal: true

require "rails_helper"

RSpec.describe Report::Builder, type: :model do
  describe "aggregation_builder" do
    it "expected build result" do
      expected = {
        total: {value_count: {field: :id}},
        artists: {terms: {field: "report_val_sorted_artist_ids", size: 10_000}},
        availability_status: {terms: {field: "availability_status", size: 999}},
        object_categories: {terms: {field: "report_val_sorted_object_category_ids", size: 999}, aggs: {techniques: {terms: {field: "report_val_sorted_technique_ids", size: 999}}, techniques_missing: {missing: {field: "report_val_sorted_technique_ids"}}}},
        object_categories_split: {terms: {field: "report_val_sorted_object_category_ids", size: 999}, aggs: {techniques: {terms: {field: "techniques.id", size: 999}}, techniques_missing: {missing: {field: "techniques.id"}}}},
        subset: {terms: {field: "subset_id", size: 999}},
        cluster: {terms: {field: "cluster.id", size: 999}},
        cluster_missing: {missing: {field: "cluster.id"}},
        permanently_fixed: {terms: {field: "permanently_fixed", size: 999}},
        permanently_fixed_missing: {missing: {field: "permanently_fixed"}},
        owner_missing: {missing: {field: "owner.id"}},
        owner: {terms: {field: "owner.id", size: 999}},
        refound: {terms: {field: "refound", size: 999}},
        inventoried: {terms: {field: "inventoried", size: 999}},
        new_found: {terms: {field: "new_found", size: 999}},
        style: {terms: {field: "style_id", size: 999}},
        frame_type: {terms: {field: "frame_type_id", size: 999}},
        condition_work: {terms: {field: "condition_work.id", size: 999}},
        condition_work_missing: {missing: {field: "condition_work.id"}},
        condition_frame: {terms: {field: "condition_frame.id", size: 999}}, condition_frame_missing: {missing: {field: "condition_frame.id"}},
        sources: {terms: {field: "sources.id", size: 999}}, sources_missing: {missing: {field: "sources.id"}},
        tag_list: {terms: {field: "tag_list", size: 999}}, tag_list_missing: {missing: {field: "tag_list"}},
        placeability: {terms: {field: "placeability.id", size: 999}}, placeability_missing: {missing: {field: "placeability.id"}}, themes: {terms: {field: "themes.id", size: 999}}, themes_missing: {missing: {field: "themes.id"}},
        for_purchase: {terms: {field: "for_purchase", size: 999}},
        for_rent: {terms: {field: "for_rent", size: 999}},
        damage_types: {terms: {field: "damage_types.id", size: 999}},
        frame_damage_types: {terms: {field: "frame_damage_types.id", size: 999}},
        abstract_or_figurative: {terms: {field: "abstract_or_figurative", size: 999}},
        abstract_or_figurative_missing: {missing: {field: "abstract_or_figurative"}}, grade_within_collection: {terms: {field: "grade_within_collection", size: 999}}, grade_within_collection_missing: {missing: {field: "grade_within_collection"}}, object_format_code: {terms: {field: "object_format_code", size: 999}}, object_format_code_missing: {missing: {field: "object_format_code"}}, market_value: {terms: {field: "market_value", size: 999}},
        market_value_min_ignore_super_missing: {aggs: {market_value_ignore_super_missing: {aggs: {balance_category: {terms: {field: "balance_category.id", size: 999}}, balance_category_missing: {missing: {field: "balance_category.id"}}}, missing: {field: :market_value}}}, missing: {field: :market_value_min}},
        replacement_value: {terms: {field: "replacement_value", size: 999}},
        replacement_value_min_ignore_super_missing: {aggs: {replacement_value_ignore_super_missing: {aggs: {missing_explainer_missing: {missing: {field: :replacement_value}}}, missing: {field: :replacement_value}}}, missing: {field: :replacement_value_min}},
        object_creation_year: {terms: {field: "object_creation_year", size: 999}}, object_creation_year_missing: {missing: {field: "object_creation_year"}}, purchase_year: {terms: {field: "purchase_year", size: 999}}, purchase_year_missing: {missing: {field: "purchase_year"}}, publish: {terms: {field: "publish", size: 999}}, publish_missing: {missing: {field: "publish"}}, image_rights: {terms: {field: "image_rights", size: 999}}, image_rights_missing: {missing: {field: "image_rights"}},
        location_raw: {terms: {field: "location_raw", size: 999}, aggs: {
          location_floor_raw: {terms: {field: "location_floor_raw", size: 999}, aggs: {
            location_detail_raw: {terms: {field: "location_detail_raw", size: 999}}
          }}
        }},
        market_value_range: {aggs: {market_value_max: {terms: {field: "market_value_max", size: 999}}}, terms: {field: :market_value_min, size: 999}},
        minimum_bid_missing: {missing: {field: "minimum_bid"}},
        purchase_price_in_eur_missing: {missing: {field: "purchase_price_in_eur"}},
        replacement_value_range: {aggs: {replacement_value_max: {terms: {field: "replacement_value_max", size: 999}}}, terms: {field: :replacement_value_min, size: 999}},
        selling_price_missing: {missing: {field: "selling_price"}},
        minimum_bid: {terms: {field: "minimum_bid", size: 999}},
        purchase_price_in_eur: {terms: {field: "purchase_price_in_eur", size: 999}},
        selling_price: {terms: {field: "selling_price", size: 999}},
        work_sets: {terms: {field: "work_sets.id", size: 999}},
        work_status: {terms: {field: "work_status.id", size: 999}},
        work_status_missing: {missing: {field: "work_status.id"}},
        has_photo_front: {terms: {field: "has_photo_front", size: 999}}
      }
      expect(Report::Builder.aggregations).to eq(expected)
    end
  end
end
