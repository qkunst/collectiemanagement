# frozen_string_literal: true

# == Schema Information
#
# Table name: work_sets
#
#  id                    :integer          not null, primary key
#  work_set_type_id      :integer
#  identification_number :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  appraisal_notice      :text
#  comment               :text
#  uuid                  :string
#  deactivated_at        :datetime
#  works_filter_params   :json
#

require "rails_helper"

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
      expect(ws.errors[:base]).to include "artist_4 achternaam - Work Diptych Left wordt reeds geteld vanuit een groepering die het als 1 werk telt."
      expect(ws.errors[:base]).to include "artist_4 achternaam - Work Diptych Left wordt reeds gewaardeerd vanuit een andere groepering."
    end
    it "can have works exist in a multiple sets that are not all appraisable" do
      work_in_appraisable_set = work_sets(:work_diptych).works.first
      ws = WorkSet.new(works: [work_in_appraisable_set, works(:work1)], work_set_type: work_set_types(:possible_same_artist))
      expect(ws.valid?).to eq(true)
    end
  end

  describe "class methods" do
    describe ".find_by_uuid_or_id!" do
      it "raises when not found" do
        expect { WorkSet.find_by_uuid_or_id!(-1) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe ".find_by_uuid_or_id" do
      it "returns nothing when nothing is present" do
        expect(WorkSet.find_by_uuid_or_id(-1)).to eq(nil)
      end
      it "returns nil when nil is sent" do
        expect(WorkSet.find_by_uuid_or_id(nil)).to eq(nil)
      end
      it "finds by uuid" do
        ws = WorkSet.first
        expect(WorkSet.find_by_uuid_or_id(ws.uuid)).to eq(ws)
      end

      it "finds by id" do
        ws = WorkSet.first
        expect(WorkSet.find_by_uuid_or_id(ws.id)).to eq(ws)
      end
    end
  end

  describe "instance methods" do
    it "#appraisable?" do
      expect(work_sets(:work_diptych)).to be_appraisable
      expect(work_sets(:random_other_collection)).not_to be_appraisable
    end

    describe "#current_active_time_span" do
      it "may not have a current active time span" do
        expect(work_sets(:work_diptych).current_active_time_span).to eq(nil)
      end

      it "will only return active workset" do
        expect(work_sets(:work_set_collection1).current_active_time_span).to eq(nil)
        ts = time_spans(:work_set_time_span)
        ts.update(status: :active)
        expect(work_sets(:work_set_collection1).current_active_time_span).to eq(ts)
      end
    end

    describe "#can_be_accessed_by_user?(user)" do
      context "only work1" do
        let!(:work_set) { WorkSet.new(works: [works(:work1)]) }
        examples = {admin: true, user1: false, appraiser: true, collection_with_works_child_user: false, collection_with_works_user: true}
        examples.each do |k, v|
          it "returns #{v} for #{k}" do
            # assertions
            expect(work_set.most_specific_shared_collection).to eq(collections(:collection_with_works))
            expect(collections(:collection_with_works).can_be_accessed_by_user?(users(k))).to eq(v)

            expect(work_set.can_be_accessed_by_user?(users(k))).to eq(v)
          end
        end
      end
      context "work1, work2, work7" do
        let!(:work_set) { WorkSet.new(works: [works(:work2), works(:work1), works(:work7)]) }
        examples = {admin: true, user1: false, appraiser: true, collection_with_works_child_user: false, collection_with_works_user: false}
        examples.each do |k, v|
          it "returns #{v} for #{k}" do
            # assertions
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

    describe "#save" do
      it "significantly updates edit status of works" do
        work = works(:work1)
        work.update_column(:significantly_updated_at, 1.day.ago)
        work_set = WorkSet.new(works: [work], work_set_type: work_set_types(:group))
        work_set.save

        work = work.reload
        expect(work.significantly_updated_at).to be > 1.minute.ago
      end

      it "triggers async reindex of work" do
        work = works(:work1)
        expect(work).to receive(:reindex_async!)
        work_set = WorkSet.new(works: [work], work_set_type: work_set_types(:meerluik))
        work_set.save
      end
    end

    describe "#update_with_works_filter_params" do
      it "shouldn't do anything when nothing is set" do
        work_set = work_sets(:work_set_collection1)
        work_ids_before = work_set.works.map(&:id)
        expect(work_set.update_with_works_filter_params).to be_nil
        expect(work_set.works.map(&:id).sort).to eq(work_ids_before.sort)
      end

      it "should filter by ids" do
        work_set = work_sets(:dynamic_filter_by_ids)
        expect(work_set.works).to eq([])

        works = [works(:work1), works(:work2)]
        work_set.works_filter_params = {ids: works.map(&:id), collection_id: collections(:collection1).id}
        work_set.update_with_works_filter_params
        work_set.reload
        expect(work_set.works.map(&:id).sort)
      end
    end

    describe "#dynamic?" do
      it "should return false when filter is present with collection" do
        work_set = work_sets(:work_set_collection1)
        expect(work_set.dynamic?).to be_falsey
      end

      it "should return true when filter is defined wit collection" do
        work_set = work_sets(:dynamic_filter_by_ids)
        work_set.works_filter_params = {ids: works.map(&:id), collection_id: collections(:collection1).id}
        expect(work_set.dynamic?).to be_truthy
      end
    end
  end
end
