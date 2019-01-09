require 'rails_helper'

RSpec.describe WorksBatchController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "PUT #update" do
    it "replaces params in work when update (default)" do
      sign_in users(:admin)
      work1 = works(:work1)
      work2 = works(:work2)
      works = [work1, work2]

      patch :update, params: {works: works.map{|a| a.id.to_s}, work: {theme_ids: [themes(:fire).id] }, collection_id: work1.collection_id}

      work1.reload
      work2.reload
      expect(work1.themes).to include(themes(:fire))
      expect(work1.themes).not_to include(themes(:earth))
      expect(work1.themes).not_to include(themes(:wind))
      expect(work2.themes).to include(themes(:fire))
      expect(work2.themes).not_to include(themes(:wind))
    end
    it "only replaces when not empty when multiple" do
      sign_in users(:admin)
      work = works(:work1)
      works = [work]
      patch :update, params: {works: works.map{|a| a.id.to_s}, work: {location: "a", location_detail: "b", location_floor: "c" }, update_unless_empty: "jibber", collection_id: work.collection_id}
      work.reload
      expect(work.location).to eq("a")
      expect(work.location_detail).to eq("b")
      expect(work.location_floor).to eq("c")
      patch :update, params: {works: works.map{|a| a.id.to_s}, work: {location: "", location_detail: "d", location_floor: nil }, update_unless_empty: "jibber", collection_id: work.collection_id}
      work.reload
      expect(work.location).to eq("a")
      expect(work.location_detail).to eq("d")
      expect(work.location_floor).to eq("c")
    end
    it "adds to work when update_and_add" do
      sign_in users(:admin)
      work1 = works(:work1)
      work2 = works(:work2)
      works = [work1, work2]

      patch :update, params: {works: works.map{|a| a.id.to_s}, work: {theme_ids: [themes(:fire).id] }, update_and_add: "jibber", collection_id: work1.collection_id}

      work1.reload
      work2.reload
      expect(work1.themes).to include(themes(:fire))
      expect(work1.themes).to include(themes(:earth))
      expect(work1.themes).to include(themes(:wind))
      expect(work2.themes).to include(themes(:fire))
      expect(work2.themes).to include(themes(:wind))
    end
    it "changes collection" do
      sign_in users(:admin)
      work1 = works(:work1)
      work2 = works(:work2)
      works = [work1, work2]

      new_collection = collections :collection_with_works_child

      expect(work1.collection).not_to eq new_collection
      expect(work2.collection).not_to eq new_collection

      patch :update, params: {works: works.map{|a| a.id.to_s}, work: {collection_id: new_collection.id }, update_and_replace: "jibber", collection_id: work1.collection_id}

      work1.reload
      work2.reload

      expect(work1.collection).to eq new_collection
      expect(work2.collection).to eq new_collection
    end
    it "changes collection" do
      sign_in users(:admin)
      work1 = works(:work1)
      work2 = works(:work2)
      work3 = works(:work_with_private_theme)
      works = [work1, work2, work3]

      new_collection = collections :collection_with_works_child

      expect(work1.collection).not_to eq new_collection
      expect(work2.collection).not_to eq new_collection
      expect(work3.collection).not_to eq new_collection

      patch :update, params: {works: works.map{|a| a.id.to_s}, work: {collection_id: new_collection.id }, update_and_replace: "jibber", collection_id: work1.collection_id}

      work1.reload
      work2.reload
      work3.reload

      expect(work1.collection).to eq new_collection
      expect(work2.collection).to eq new_collection

      expect(work3.collection).not_to eq new_collection #'cause it doesn't validate after update...

    end
  end
  describe "PUT #update with tags" do
    # tags are somewhat different
    it "replaces params in work when update (default)" do
      sign_in users(:admin)
      work1 = works(:work1)
      work2 = works(:work2)
      works = [work1, work2]
      work1.tag_list = ["aarde"]
      work2.tag_list = ["aarde"]
      work1.save
      work2.save

      patch :update, params: {works: works.map{|a| a.id.to_s}, work: {tag_list: ["", "vuur"] }, collection_id: work1.collection_id}

      work1.reload
      work2.reload
      expect(work1.tag_list).to include("vuur")
      expect(work1.tag_list).not_to include("aarde")
      expect(work2.tag_list).to include("vuur")
      expect(work2.tag_list).not_to include("aarde")
    end
    it "adds to work when update_and_add" do
      sign_in users(:admin)
      work1 = works(:work1)
      work2 = works(:work2)
      works = [work1, work2]
      work1.tag_list = ["aarde"]
      work2.tag_list = ["aarde"]
      work1.save
      work2.save

      patch :update, params: {works: works.map{|a| a.id.to_s}, work: {tag_list: ["", "vuur"] }, update_and_add: "jibber", collection_id: work1.collection_id}

      work1.reload
      work2.reload
      expect(work1.tag_list).to include("vuur")
      expect(work1.tag_list).to include("aarde")
      expect(work2.tag_list).to include("vuur")
      expect(work2.tag_list).to include("aarde")
    end
    it "removes from work when update_and_delete" do
      sign_in users(:admin)
      work1 = works(:work1)
      work2 = works(:work2)
      works = [work1, work2]
      work1.tag_list = ["aarde", "vuur"]
      work2.tag_list = ["aarde", "vuur", "wind"]
      work1.save
      work2.save

      patch :update, params: {works: works.map{|a| a.id.to_s}, work: {tag_list: ["", "vuur"] }, update_and_delete: "jibber", collection_id: work1.collection_id}

      work1.reload
      work2.reload
      expect(work1.tag_list).not_to include("vuur")
      expect(work1.tag_list).to include("aarde")
      expect(work2.tag_list).not_to include("vuur")
      expect(work2.tag_list).to include("aarde")
      expect(work2.tag_list).to include("wind")
    end
  end
end