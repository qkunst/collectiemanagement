class Stage < ApplicationRecord
  belongs_to :previous_stage, primary_key: :id, class_name: "Stage"
  belongs_to :actual_stage, primary_key: :id, class_name: "Stage"
  has_many :next_stages, foreign_key: :previous_stage_id, class_name: "Stage"
  has_and_belongs_to_many :collections

  scope :actual_stages, ->{where( actual_stage_id: nil )}

  attr_accessor :enabled, :collection_stage

  def next_stages_actualized
    next_stages.actualize
  end

  def enabled!
    self.enabled = true
  end

  def enabled?
    self.enabled ? true : false
  end

  def completed?
    collection_stage ? collection_stage.completed? : false
  end

  def completed_at
    collection_stage ? collection_stage.completed_at : nil
  end

  def active?
    collection_stage ? collection_stage.active? : false
  end

  def non_cyclic_graph_from_here(collection=nil)
    collection_stage = collection ? collection.find_state_of_stage(self) : nil
    self.enabled! if collection_stage or !collection
    self.collection_stage = collection_stage
    graph = [[self]]
    next_stages = self.next_stages_actualized
    step = 1
    while next_stages.count > 0 and !next_stages.include? self
      stages = next_stages
      next_stages = []
      stages.each do | stage |
        collection_stage = collection ? collection.find_state_of_stage(stage) : nil
        stage.enabled! if collection_stage or !collection
        stage.collection_stage = collection_stage
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
