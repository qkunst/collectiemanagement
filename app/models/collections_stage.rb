class CollectionsStage < ApplicationRecord
  belongs_to :stage
  belongs_to :collection

  time_as_boolean :completed

  def previous_collections_stage
    @previous_collections_stage ||= collection.find_state_of_stage(stage.previous_stage)
  end

  def active?
    previous_collections_stage and previous_collections_stage.completed? and !completed?
  end

end
