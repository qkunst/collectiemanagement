class Stage < ApplicationRecord
  belongs_to :previous_stage, primary_key: :id, class_name: "Stage"
  belongs_to :actual_stage, primary_key: :id, class_name: "Stage"
  has_many :next_stages, foreign_key: :previous_stage_id, class_name: "Stage"
  has_and_belongs_to_many :collections

  scope :actual_stages, ->{where( actual_stage_id: nil )}

  attr_accessor :enabled, :completed

  def next_stages_actualized
    next_stages.actualize
  end

  def non_cyclic_graph_from_here(collection=nil)
    collection_stage = collection ? collection.find_state_of_stage(self) : nil
    self.enabled = true if collection_stage or !collection
    self.completed = true if collection_stage and collection_stage.completed?
    graph = [[self]]
    next_stages = self.next_stages_actualized
    step = 1
    while next_stages.count > 0 and !next_stages.include? self
      stages = next_stages
      next_stages = []
      stages.each do | stage |
        collection_stage = collection ? collection.find_state_of_stage(stage) : nil
        stage.enabled = true if collection_stage or !collection
        stage.completed = true if collection_stage and collection_stage.completed?
        branch_index = stages.index(stage)
        if graph[branch_index].nil?
          graph[branch_index] = (step.times.collect{ nil } + [stage])
        else
          graph[branch_index] << stage
        end
        next_stages += stage.next_stages_actualized
      end
      next_stages = next_stages.uniq
      step += 1
    end
    graph
  end

  class << self
    def start
      self.starts.first
    end
    def starts
      self.where(previous_stage: nil)
    end
    def actualize
      Stage.unscoped.where(id: self.all.collect{|a| a.actual_stage_id ? a.actual_stage_id : a.id})
    end
  end
end
