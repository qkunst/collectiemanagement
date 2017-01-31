class CollectionsStage < ApplicationRecord
  belongs_to :stage
  belongs_to :collection

  time_as_boolean :completed


  class << self
    def find_by_stage(stage)
      self.all.each do |a|
        return a if a.stage == stage
      end
      return nil
    end
  end
end
