module Work::PreloadRelationsForDisplay
  extend ActiveSupport::Concern

  class_methods do
    def preload_relations_for_display(display)
      case display
      when :compact
        self.includes(:collection)
      when :detailed, :complete
        self.includes(:collection, :techniques, :object_categories, :damage_types, :frame_damage_types, :medium, :style, :themes, :subset, :sources, :attachments, :appraisals, :condition_work, :condition_frame, :cluster, artists: [:artist_involvements])
      when :limited, :limited_auction
        self.includes(:collection, :techniques, :object_categories, :medium, :condition_work, :condition_frame)
      end
    end
  end
end