# frozen_string_literal: true

module Work::PreloadRelationsForDisplay
  extend ActiveSupport::Concern

  class_methods do
    def preload_relations_for_display(display)
      case display
      when :compact
        includes(:collection)
      when :limited, :limited_auction
        includes(:collection, :techniques, :object_categories, :medium, :condition_work, :condition_frame, artists: [:artist_involvements], work_sets: [:work_set_type])
      else
        includes(:collection, :created_by, :library_items, :purchase_price_currency, :techniques, :object_categories, :time_spans, :damage_types, :frame_damage_types, :frame_type, :medium, :style, :themes, :subset, :sources, :owner, :work_status, :attachments, :appraisals, :condition_work, :condition_frame, :cluster, :placeability, :balance_category, :work_set_types, :geoname_summary, artists: [:artist_involvements], work_sets: [:work_set_type, :appraisals])
      end
    end
  end
end
