# frozen_string_literal: true

require "rails_helper"

class WorksFilteringTestClass
  include Works::Filtering

  def initialize(collection:)
    @collection = collection
  end

  def current_user
    User.first
  end

  attr_writer :params

  def params
    @params || {}
  end
end

RSpec.describe Works::Filtering, type: :model do
  let(:collection) { collections(:collection1) }
  subject { WorksFilteringTestClass.new(collection:) }

  describe "#set_selection_filter" do
    it "returns empty hash when none" do
      expect(subject.send(:set_selection_filter)).to eq({"_and" => ["locality_geoname_id", "geoname_ids", "tag_list"]})
    end

    it "returns empty hash when none" do
      subject.params = {filter: {"cluster" => ["not_set"], "cluster_id" => [1, 2]}} # filter[cluster][]=not_set&filter[cluster_id][]=1&filter[cluster_id][]=2
      expect(subject.send(:set_selection_filter)).to eq({"_and" => ["locality_geoname_id", "geoname_ids", "tag_list"], "cluster" => [nil], "cluster_id" => [1, 2]})
    end

    it "translate works set uuid into an id" do
      subject.params = {filter: {"work_sets.uuid" => ["1c8988cc-b08f-4996-a0e7-cc64cb5a6096"]}}
      expect(subject.send(:set_selection_filter)).to eq({"_and" => ["locality_geoname_id", "geoname_ids", "tag_list"], "work_sets.id" => [work_sets(:work_set_collection1).id]})
    end

    it "fixes the current collection" do
      subject.params = {filter: {"work_sets.uuid" => ["1c8988cc-b08f-4996-a0e7-cc64cb5a6096"]}}
      expect(subject.send(:set_selection_filter)).to eq({"_and" => ["locality_geoname_id", "geoname_ids", "tag_list"], "work_sets.id" => [work_sets(:work_set_collection1).id]})
    end
  end

  describe "#set_works" do
    let(:ids_hash) { IdsHash.store([works(:work1).id, works(:work2).id]) }

    it "returns all works if no filters" do
      expect(subject.send(:set_works)).to eq(collection.works_including_child_works)
    end

    it "returns works in a hash" do
      subject.params = {work_ids_hash: ids_hash.hashed}
      expect(subject.send(:set_works)).to eq([works(:work1), works(:work2)])
    end
  end
end
