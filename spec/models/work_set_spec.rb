# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkSet, type: :model do
  it "has and belongs to many works" do
    expect(work_sets(:work_diptych).works).to match_array([works(:work_diptych_1), works(:work_diptych_2)])
  end

  it "requires a type" do
    ws = WorkSet.create
    expect(ws.errors.details[:work_set_type]).to include({error: :blank})
  end

  describe "scopes" do
    describe ".accepts_appraisals" do
      it "should return only diptych" do
        expect(WorkSet.accepts_appraisals).not_to include(work_sets(:random_other_collection))
        expect(WorkSet.accepts_appraisals).to include(work_sets(:work_diptych))
      end
    end
  end

  describe "validations" do
    it "cannot have works exist in two appraisable sets" do
      work_in_appraisable_set = work_sets(:work_diptych).works.first
      ws = WorkSet.new(works: [work_in_appraisable_set, works(:work1)], work_set_type: work_set_types(:meerluik))
      expect(ws.valid?).to eq(false)
      expect(ws.errors[:base]).to include "Work Diptych Left wordt reeds gewaardeerd vanuit een andere groepering."
      expect(ws.errors[:base]).to include "Work Diptych Left wordt reeds uniek geteld vanuit een andere groepering."
    end
    it "can have works exist in a multiple sets that are not all appraisable" do
      work_in_appraisable_set = work_sets(:work_diptych).works.first
      ws = WorkSet.new(works: [work_in_appraisable_set, works(:work1)], work_set_type: work_set_types(:possible_same_artist))
      expect(ws.valid?).to eq(true)
    end
  end

  describe "instance methods" do
    it "#appraisable?" do
      expect(work_sets(:work_diptych)).to be_appraisable
      expect(work_sets(:random_other_collection)).not_to be_appraisable
    end

    describe "#can_be_accessed_by_user?(user)" do
      context "only work1" do
        let!(:work_set) { WorkSet.new(works: [works(:work1)]) }
        examples = {admin: true, user1: false, appraiser: true, collection_with_works_child_user: false,  collection_with_works_user: true}
        examples.each do |k,v|
          it "returns #{v} for #{k}" do
            #assertions
            expect(work_set.most_specific_shared_collection).to eq(collections(:collection_with_works))
            expect(collections(:collection_with_works).can_be_accessed_by_user?(users(k))).to eq(v)

            expect(work_set.can_be_accessed_by_user?(users(k))).to eq(v)
          end
        end
      end
      context "work1, work2, work7" do
        let!(:work_set) { WorkSet.new(works: [works(:work2), works(:work1), works(:work7)]) }
        examples = {admin: true, user1: false, appraiser: true, collection_with_works_child_user: false,  collection_with_works_user: false}
        examples.each do |k,v|
          it "returns #{v} for #{k}" do
            #assertions
            expect(work_set.most_specific_shared_collection).to eq(collections(:collection1))
            expect(collections(:collection1).can_be_accessed_by_user?(users(k))).to eq(v)

            expect(work_set.can_be_accessed_by_user?(users(k))).to eq(v)
          end
        end
      end
    end

    describe "#most_specific_shared_collection" do
      it "returns single work's collection as base" do
        ws = WorkSet.new(works: [works(:work1)])
        expect(ws.most_specific_shared_collection).to eq(collections(:collection_with_works))
      end
      it "returns shared collection as base" do
        ws = WorkSet.new(works: [works(:work2), works(:work1)])
        expect(ws.most_specific_shared_collection).to eq(collections(:collection_with_works))
      end
      it "returns shared parent collection as base" do
        ws = WorkSet.new(works: [works(:work2), works(:work1), works(:work7)])
        expect(ws.most_specific_shared_collection).to eq(collections(:collection1))
      end
      it "returns nil when nothing shared" do
        ws = WorkSet.new(works: [works(:work2), works(:work1), works(:work6)])
        expect(ws.most_specific_shared_collection).to eq(nil)
      end
    end


  end
end
