# frozen_string_literal: true

require "rails_helper"

class WorkIdsTestClass
  include Works::WorkIds

  attr_accessor :params, :works

  def initialize(current_user:)
    @current_user = current_user
    @params = {}
  end

  def current_user
    @current_user
  end
end

RSpec.describe Works::WorkIds, type: :model do
  subject(:work_ids_helper) { WorkIdsTestClass.new(current_user: users(:qkunst_with_collection)) }

  describe "#works_to_work_ids_hash" do
    it "stores the current work ids in an IdsHash" do
      work_ids_helper.works = [works(:work1), works(:work2)]

      expect(work_ids_helper.works_to_work_ids_hash).to eq(IdsHash.store([works(:work1).id, works(:work2).id]).hashed)
    end
  end

  describe "#set_works_by_work_ids_or_work_ids_hash" do
    it "loads explicit ids and filters out inaccessible works" do
      work_ids_helper.params = {work_ids: [works(:work1).id.to_s, works(:work6).id.to_s]}

      work_ids_helper.set_works_by_work_ids_or_work_ids_hash

      expect(work_ids_helper.works).to match_array([works(:work1)])
    end

    it "loads ids through a stored hash" do
      ids_hash = IdsHash.store([works(:work1).id, works(:work6).id])
      work_ids_helper.params = {work_ids_hash: ids_hash.hashed}

      work_ids_helper.set_works_by_work_ids_or_work_ids_hash

      expect(work_ids_helper.works).to match_array([works(:work1)])
    end
  end
end
