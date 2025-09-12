# frozen_string_literal: true

module Work::Reflecting
  extend ActiveSupport::Concern

  MAX_ACCEPTABLE_DEPTH_FOR_2D = 10 # 10cm

  class_methods do
    def has_manies
      @@has_manies ||= Work.reflections.to_a.select { |a| a[1].is_a?(ActiveRecord::Reflection::HasManyReflection) }.map(&:first).map(&:to_sym)
    end

    def has_and_belongs_to_manies
      @@has_and_belongs_to_manies ||= Work.reflections.to_a.select { |a| a[1].is_a?(ActiveRecord::Reflection::HasAndBelongsToManyReflection) }.map(&:first).map(&:to_sym)
    end

    def belong_tos
      @@belong_tos ||= Work.reflections.to_a.select { |a| a[1].is_a?(ActiveRecord::Reflection::BelongsToReflection) }.map(&:first).map(&:to_sym)
    end
  end
end
