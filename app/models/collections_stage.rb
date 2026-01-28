# frozen_string_literal: true
# == Schema Information
#
# Table name: collections_stages
#
#  id            :integer          not null, primary key
#  collection_id :integer
#  stage_id      :integer
#  completed_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
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
