# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cluster, type: :model do
  describe  "callbacks" do
    describe "before_destroy :remove_cluster_id_at_works" do
      it "should work" do
        c=Cluster.first
        c_id = c.id
        expect(c.works.count).to be > 0
        c.destroy
        expect(Work.where(cluster_id: c_id).count).to eq(0)
      end
    end
  end

  describe "class methods" do
    describe "remove_cluster_id_where_cluster_is_removed" do
      it "should do the cleanup" do
        w = works(:work6)
        w.cluster_id = -1
        w.save
        expect(w.cluster_id).to eq(-1)
        expect(w.cluster).to eq(nil)
        Cluster.remove_cluster_id_where_cluster_is_removed!
        w.reload
        expect(w.cluster_id).to eq(nil)
        expect(w.cluster).to eq(nil)
        expect(Cluster.first.works.count).to be > 0
      end
    end
  end

end
