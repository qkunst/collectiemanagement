# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stage, type: :model do
  describe "methdos" do
    describe "#non_cyclic_graph_from_here" do
      it "should be available from start" do
        Stage.start.non_cyclic_graph_from_here
      end
      it "should match te expected result" do
        tree = Stage.start.non_cyclic_graph_from_here
        expect(tree).to eq([
          [stages(:stage1), stages(:stage2a), stages(:stage3)],
          [nil, stages(:stage2b)]
        ])
        tree.each do |branch|
          branch.each do |leaf|
            if leaf
              expect(leaf.completed?).to be_falsy
              expect(leaf.enabled?).to eq(true)
            end
          end
        end
      end
      it "should take a collection as a parameter (and then consider all stages to be disabled)" do
        tree = Stage.start.non_cyclic_graph_from_here(Collection.new)
        expect(tree).to eq([
          [stages(:stage1), stages(:stage2a), stages(:stage3)],
          [nil, stages(:stage2b)]
        ])
        tree.each do |branch|
          branch.each do |leaf|
            if leaf
              expect(leaf.completed?).to be_falsy
              expect(leaf.enabled?).to be_falsy
            end
          end
        end
      end
      it "should take a collection as a parameter (and mark stages correctly)" do
        collection = Collection.new(collections_stages: [CollectionsStage.new(stage: stages(:stage1), completed: true)])
        tree = Stage.start.non_cyclic_graph_from_here(collection)
        expect(tree).to eq([
          [stages(:stage1), stages(:stage2a), stages(:stage3)],
          [nil, stages(:stage2b)]
        ])
        tree.each do |branch|
          branch.each do |leaf|
            if leaf && (leaf == stages(:stage1))
              expect(leaf.completed?).to eq(true)
              expect(leaf.enabled?).to eq(true)
              expect(leaf.active?).to be_falsy
            elsif leaf
              expect(leaf.completed?).to be_falsy
              expect(leaf.active?).to be_falsy
              expect(leaf.enabled?).to be_falsy
            end
          end
        end
      end
      it "should not mark the combination stage as active when stages before are inactive" do
        collection = Collection.new(collections_stages: [
          CollectionsStage.new(stage: stages(:stage1), completed: false),
          CollectionsStage.new(stage: stages(:stage3), completed: false)
        ])
        tree = Stage.start.non_cyclic_graph_from_here(collection)
        expect(tree).to eq([
          [stages(:stage1), stages(:stage2a), stages(:stage3)],
          [nil, stages(:stage2b)]
        ])
        tree.each do |branch|
          branch.each do |leaf|
            if leaf && (leaf == stages(:stage1))
              expect(leaf.completed?).to eq(false)
              expect(leaf.enabled?).to eq(true)
            elsif leaf && ((leaf == stages(:stage2a)) || (leaf == stages(:stage2b)))
              expect(leaf.completed?).to be_falsy
              expect(leaf.active?).to be_falsy
              expect(leaf.enabled?).to be_falsy
            elsif leaf
              expect(leaf.completed?).to be_falsy
              expect(leaf.active?).to be_falsy
              expect(leaf.enabled?).to eq(true)
            end
          end
        end
      end
    end
  end
  describe "Class methods" do
    describe ".start" do
      it "should return the first stage" do
        expect(Stage.start).to eq(stages(:stage1))
      end
    end
  end
end
