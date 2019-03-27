# frozen_string_literal: true

class CollectionsStage < ApplicationRecord
  belongs_to :stage
  belongs_to :collection

  time_as_boolean :completed

  scope :delivery, ->{ joins(:stage).where(stages: {name: "Oplevering"})}

  def previous_collections_stage
    @previous_collections_stage ||= collection.find_state_of_stage(stage.previous_stage)
  end

  def active?
    (previous_collections_stage and previous_collections_stage.completed? and !completed?) or
    (stage.previous_stage.nil? and !completed?)
  end

end
