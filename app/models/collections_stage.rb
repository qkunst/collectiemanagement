# frozen_string_literal: true

# == Schema Information
#
# Table name: collections_stages
#
#  id            :bigint           not null, primary key
#  completed_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  collection_id :bigint
#  stage_id      :bigint
#
class CollectionsStage < ApplicationRecord
  belongs_to :stage
  belongs_to :collection

  time_as_boolean :completed

  scope :delivery, -> { joins(:stage).where(stages: {name: "Oplevering"}) }

  def previous_collections_stage
    @previous_collections_stage ||= collection.find_state_of_stage(stage.previous_stage)
  end

  def active?
    (previous_collections_stage&.completed? && !completed?) ||
      (stage.previous_stage.nil? && !completed?)
  end
end
