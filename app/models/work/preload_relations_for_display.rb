# frozen_string_literal: true

module Work::PreloadRelationsForDisplay
  extend ActiveSupport::Concern

  class_methods do
    def preload_relations_for_display(display)
      case display
      when :compact
        includes(:collection)
      when :limited, :limited_auction, :limited_selling_price, :limited_selling_price_and_default_rent_price, :limited_default_rent_price, :limited_business_rent_price, :limited_selling_price_and_business_rent_price
        includes(:collection, :techniques, :object_categories, :medium, :condition_work, :condition_frame, artists: [:artist_involvements], work_sets: [:work_set_type])
      else
        includes(:collection, :import_collection, :created_by, :library_items, :purchase_price_currency, :techniques, :object_categories, :time_spans, :damage_types, :frame_damage_types, :frame_type, :medium, :style, :themes, :subset, :sources, :owner, :work_status, :attachments, :appraisals, :condition_work, :condition_frame, :cluster, :placeability, :balance_category, :work_set_types, :geoname_summary, :collection_attributes, time_spans: [:contact], artists: [:artist_involvements, :collection_attributes], work_sets: [:time_spans, :work_set_type, :appraisals])
      end
    end
  end
end
