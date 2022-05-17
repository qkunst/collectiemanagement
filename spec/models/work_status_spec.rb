# == Schema Information
#
# Table name: work_statuses
#
#  id                                  :bigint           not null, primary key
#  hide                                :boolean          default(FALSE)
#  name                                :string
#  set_work_as_removed_from_collection :boolean
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#
require_relative "../rails_helper"

RSpec.describe WorkStatus, type: :model do
  describe "#set_work_as_removed_from_collection's impact on work" do
    it "doesn't result in a work being set as removed from collection if not set" do
      w = works(:work1)
      w.work_status = work_statuses(:niet_in_gebruik)
      w.save
      w.reload
      expect(w.removed_from_collection?).to be_falsey
    end

    it "does result in a work being set as removed from collection if set" do
      w = works(:work1)
      w.work_status = work_statuses(:afgestoten)
      w.save
      w.reload
      expect(w.removed_from_collection?).to be_truthy
    end

    it "doesn't update an already removed work if set" do
      w = works(:work1)
      date = DateTime.new(2000,1,1)
      w.update(removed_from_collection_at: date)

      w.work_status = work_statuses(:afgestoten)
      w.save
      w.reload
      expect(w.removed_from_collection?).to be_truthy
      expect(w.removed_from_collection_at).to eq(date)
    end
  end
end
